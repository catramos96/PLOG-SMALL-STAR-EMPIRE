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