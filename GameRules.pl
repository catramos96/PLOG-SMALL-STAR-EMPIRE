/************************
*		GAME RULES		*
*************************
Rules related to game function
Validation of arguments
*/		

getPossibleMoves(Board,Player,M) :- playerGetShips(Player,Ships), playerGetTeam(Player,Team),
									possibleMovesAux(Board,Team,Ships,[],M).

possibleMovesAux(Board,Team,[S|Sn],T,M) :- 	getPosition(S,R,C),nl,getAdjFreeCells(Board,R,C,Team,Cells),
											append(T,[Cells|[]],T1), possibleMovesAux(Board,Team,Sn,T1,M).
possibleMovesAux(_,_,_,M,M).


/* ------------------------- */									
getPossibleMovesValued(Board,Player,ValuedList) :- 	getPossibleMoves(Board,Player,AllMoves),
													setValuedMoves(Board,AllMoves,[],ValuedList).

setValuedMoves(_,[],FinalList,FinalList).									
setValuedMoves(Board,[Row|Remainder],List,FinalList) :- setValuedMovesByRow(Board,Row,[],RowList),
														append(List,[RowList|[]],NewList),
														setValuedMoves(Board,Remainder,NewList,FinalList).

setValuedMovesByRow(_,[],FinalList,FinalList).
setValuedMovesByRow(Board,[[R|[C|[]]]|Remainder],List,FinalList) :- getBoardCell(Board,R,C,[SystemType|_]),
																	getValue(SystemType,Value),
																	append(List,[Value|[]],NewList),
																	setValuedMovesByRow(Board,Remainder,NewList,FinalList).
												
getValue(SystemType,SystemType) :- SystemType == 1 ; SystemType == 2 ; SystemType == 3 .
getValue(SystemType,4) :- (SystemType == 4 ; SystemType == 5).								%TEMPORARIO
getValue(_,0).

/* Ship e Pos correspondem a row e col a procurar no AllMoves */
getBestMove(Board,Player,ValuedList,Ship,Pos) :- searchBestMove(ValuedList,ValuedList,1,1,1,Ship,Pos).

searchBestMove(_,[],_,BestR,BestC,BestR,BestC) .
searchBestMove(ValuedList,[Row|Remainder],Ri,Rt,Ct,BestR,BestC) :- 	searchBestMoveByShip(ValuedList,Row,Ri,1,Rt,Ct,PartR,PartC),
																	NewRi is Ri + 1,
																	searchBestMove(ValuedList,Remainder,NewRi,PartR,PartC,BestR,BestC).

searchBestMoveByShip(_,[],_,_,BestR,BestC,BestR,BestC) .																
searchBestMoveByShip(ValuedList,[Value|Remainder],Ri,Ci,Rt,Ct,BestR,BestC) :- 	getPositionIn(Rt,Ct,ValuedList,Value2),
																				Value > Value2,
																				NewC is Ci + 1,
																				searchBestMoveByShip(ValuedList,Remainder,Ri,NewC,Ri,Ci,BestR,BestC) .																	
searchBestMoveByShip(ValuedList,[_|Remainder],Ri,Ci,Rt,Ct,BestR,BestC) :- 	NewC is Ci + 1,  
																			searchBestMoveByShip(ValuedList,Remainder,Ri,NewC,Rt,Ct,BestR,BestC).

getPositionIn(R,C,List,Value) :- nth1(R,List,Row), nth1(C,Row,Value).

															
/* ------------------------- */									

															
validMove(M,Pi,Ri,Ci,Rf,Cf) :- 	playerGetShips(Pi,Ships),				/*Get Ships*/
								getListElem(Ships,Pos,[Ri|[Ci|[]]]),	/*Get Position of Ship*/
								getListElem(M,Pos,ShipsMoves),			/*Get Move for Ship Position*/
								getListElem(ShipsMoves,_,[Rf|[Cf|[]]]).	/*Check if the final Position is in the possibles moves list*/
										
validMove(_,_,_,_,_,_) :- 	error(1), fail.



updateValidShips(Board,Player,FinalPlayer) :- playerGetShips(Player,Ships),validShips(Board,Player,Ships,FinalPlayer).		%VALID_SHIPS

validShips(_,P,[],P).
validShips(Board,Player,[S|Sn],FinalPlayer) :- 	getPosition(S,R,C), playerGetTeam(Player,Team),
												getAdjFreeCells(Board,R,C,Team,[]), !,
												playerRemShip(Player,S,PlayerT), validShips(Board,PlayerT,Sn,FinalPlayer).
validShips(Board,Player,[_|Sn],FinalPlayer) :- 	validShips(Board,Player,Sn,FinalPlayer).



setShip(Board,Row,Column,ShipsAdd,Final) :- 		getBoardCell(Board,Row,Column,Cell),									%SET_SHIP
													(	(ShipsAdd is 1 , incCellShips(Cell,NewCell));
														(ShipsAdd is -1, decCellShips(Cell,NewCell))	),
													getCellShips(NewCell,NewShips), NewShips > -1,
													setBoardCell(Board,Row,Column,NewCell,Final).

													
													
setDominion(Board,Team,Row,Column,Type,Final) :-	getBoardCell(Board,Row,Column,Cell),									%SET_DOMINION
													getCellDominion(Cell,-1), !,
													dominion(Id,Team,Type), !,
													setCellDominion(Cell,Id,NewCell), !,
													setBoardCell(Board,Row,Column,NewCell,Final).

%COMPUTER

chooseType(Board,Player,AdjCells,MyTeam,Type)	:- 	getTradePointsAux(Board,AdjCells,MyTeam,0,Num),
													Num > 0, 
													getListElem(Player,2,Trades),
													length(Trades,Length), Length < 4, 	/* Ainda posso colocar Trades*/
													Type = 'T'.
chooseType(_,_,_,_,Type) :- Type = 'C'.	
													
getRandShip(Player,AllMoves,R,C,ShipMoves) :- 	playerGetShips(Player,Ships), 
												length(Ships,Length),
												X is Length +1,
												random(1,X,Rand), 
												nth1(Rand,Ships,Value),
												getPosition(Value,R,C),	/* posicao do barco aleatorio */
												nth1(Rand,AllMoves,ShipMoves) .	/* todos os movimentos do barco aleatorio */						

getRandMove(ShipMoves,R,C) :- 	length(ShipMoves, Length),
								X is Length +1,
								random(1,X,Rand),
								nth1(Rand,ShipMoves,[R|[C|[]]]) .