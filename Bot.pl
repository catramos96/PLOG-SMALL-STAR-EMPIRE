/************************
*		   BOT			*
************************/

/* 
this method chooses the control that is placed by the computer
will choose trade if there are adjacent enemies, or colony otherwise.
the trade choice will depend on the player level and if there are still possible trades to be placed.
*/
chooseType(Level,Board,Player,AdjCells,MyTeam,Type)	:-  getTradePointsAux(Board,AdjCells,MyTeam,0,Num),
														((Level == 2, Num > 1) ; 
														(Level == 1, Num > 0)) ,
														playerGetTrades(Player,Trades),
														length(Trades,Length), Length < 4, 	
														Type = 'T'.
chooseType(_,_,_,_,_,Type) :- Type = 'C'.		
			
/*
this method chooses a random ship, in the Ships of the Player, that will be moved.
The initial position of the move, will be the position of this ship.
*/			
getRandShip(Player,AllMoves,R,C,ShipMoves) :- 	playerGetShips(Player,Ships), 
												length(Ships,Length),
												X is Length +1,
												random(1,X,Rand), 	%random ship of the available ships
												nth1(Rand,Ships,Value),
												getPosition(Value,R,C),			%position of the ship
												nth1(Rand,AllMoves,ShipMoves) .	%list of PossibleMoves for this ship						
/*
method that chooses a random move considering the ship's possible plays.
*/
getRandMove(ShipMoves,R,C) :- 	length(ShipMoves, Length),
								X is Length +1,
								random(1,X,Rand),
								nth1(Rand,ShipMoves,[R|[C|[]]]) .
								
/*
returns the ValuedList matrix
*/
getPossibleMovesValued(Board,Player,AllMoves,ValuedList) :- setValuedMoves(Board,Player,AllMoves,[],ValuedList).

/*
creates a matrix that is equivalent to the matrix AllMoves, giving the moves a value
*/
setValuedMoves(_,_,[],FinalList,FinalList).									
setValuedMoves(Board,Player,[Row|Remainder],List,FinalList) :- 	setValuedMovesByRow(Board,Player,Row,[],RowList),
																append(List,[RowList|[]],NewList),
																setValuedMoves(Board,Player,Remainder,NewList,FinalList).
/*
auxiliary method of the setValuedMoves that creates one of the matrix's row
*/
setValuedMovesByRow(_,_,[],FinalList,FinalList).
setValuedMovesByRow(Board,Player,[[R|[C|[]]]|Remainder],List,FinalList) :- 	getBoardCell(Board,R,C,[SystemType|_]),
																			getValue(Board,Player,SystemType,Value),
																			append(List,[Value|[]],NewList),
																			setValuedMovesByRow(Board,Player,Remainder,NewList,FinalList).

																			
/*
returns the number of colonized nebulae by the player of the same color
*/
hasNebulae(_,[],_,_,NewAcc,NewAcc).
hasNebulae(Board,[[R|[C|[]]]|Lb],MyTeam,SystemType,Acc,NewAcc) :- 	getBoardCell(Board,R,C,[SystemID|[DominionID|_]]),
																	dominion(DominionID,MyTeam,_),systemType(SystemID,SystemType,_),
																	Temp is Acc + 1,
																	hasNebulae(Board,Lb,MyTeam,SystemType,Temp,NewAcc).
																	
/*
transforms a cell to a value
*/
getValue(_,_,SystemType,SystemType) :- SystemType == 1 ; SystemType == 2 ; SystemType == 3 .
getValue(Board,Player,SystemType,Value) :- 	(SystemType == 4 ; SystemType == 5), 
											playerTerritory(Player,Territory), 
											playerGetTeam(Player,MyTeam),
											hasNebulae(Board,Territory,MyTeam,SystemType,0,Num),
											Num > 0, Value is 4.
getValue(_,_,SystemType,2) :- (SystemType == 4 ; SystemType == 5).
getValue(_,_,_,0).

/*
returns the matrix position of the matrix ValuedList that contains the higher value
*/
getBestMove(ValuedList,Ship,Pos) :- searchBestMove(ValuedList,ValuedList,1,1,1,Ship,Pos) .

/*
searches ValuedList for the position that has the best value
*/
searchBestMove(_,[],_,BestR,BestC,BestR,BestC) .
searchBestMove(ValuedList,[Row|Remainder],Ri,Rt,Ct,BestR,BestC) :- 	searchBestMoveByShip(ValuedList,Row,Ri,1,Rt,Ct,PartR,PartC),
																	NewRi is Ri + 1,
																	searchBestMove(ValuedList,Remainder,NewRi,PartR,PartC,BestR,BestC).

/*
Auxiliary method that returns a ship's possible position that has the best value
*/
searchBestMoveByShip(_,[],_,_,BestR,BestC,BestR,BestC) .															
searchBestMoveByShip(ValuedList,[Value|Remainder],Ri,Ci,Rt,Ct,BestR,BestC) :- 	getCell(ValuedList,Rt,Ct,Value2),
																				Value > Value2,
																				NewC is Ci + 1,
																				searchBestMoveByShip(ValuedList,Remainder,Ri,NewC,Ri,Ci,BestR,BestC) .																	
searchBestMoveByShip(ValuedList,[_|Remainder],Ri,Ci,Rt,Ct,BestR,BestC) :- 	NewC is Ci + 1,  
																			searchBestMoveByShip(ValuedList,Remainder,Ri,NewC,Rt,Ct,BestR,BestC).