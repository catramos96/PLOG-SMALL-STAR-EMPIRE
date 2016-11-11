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

displayPossibleMoves(P,M) :- 		playerGetShips(P,S) , write('POSSIBLE MOVES'),nl,
									displayMovesAux(S,M),nl.

displayMovesAux([],_).
displayMovesAux(_,[]).
displayMovesAux([S|Sn],[M|Mn]) :- 	write('SHIP - '), displayList(S),nl,
									displayList(M),nl, !,
									displayMovesAux(Sn,Mn).
									

%CONFIRMATION																
validMove(Board,M,Pi,Ri,Ci,Rf,Cf) :- 	playerGetShips(Pi,Ships),				/*Get Ships*/
										getListElem(Ships,Pos,[Ri|[Ci|[]]]),	/*Get Position of Ship*/
										getListElem(M,Pos,ShipsMoves),			/*Get Move for Ship Position*/
										getListElem(ShipsMoves,_,[Rf|[Cf|[]]]).	/*Check if the final Position is in the possibles moves list*/

/*testMove(B,Pi,Ri,Ci,Rf,Cf) :- 	getCellDirection(B,Ri,Ci,Rf,Cf,D), !,														%TEST_MOVE
								playerGetTeam(Pi,Team),
								testMoveAux(B,Team,Ri,Ci,Rf,Cf,D).

testMoveAux(B,T,Ri,Ci,Rf,Cf,D) :- 	getCellInDirection(B,Ri,Ci,D,Rt,Ct,NextCell), !,					
									(getCellTeam(NextCell,' '); getCellTeam(NextCell,T)), !,		
									(getCellSystem(NextCell,SType) , SType \= 7), !,		
									((Rt is Rf , Ct is Cf);												
									(getCellDirection(B,Rt,Ct,Rf,Cf,D),testMoveAux(B,T,Rt,Ct,Rf,Cf,D))).*/

%UPDATE

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
setShip(Board,_,_,_,_,Board).

setDominion(Board,Team,Row,Column,Type,Final) :-	getBoardCell(Board,Row,Column,Cell),									%SET_DOMINION
													getCellDominion(Cell,-1),
													dominion(Id,Team,Type), setCellDominion(Cell,Id,NewCell),
													setBoardCell(Board,Row,Column,NewCell,Final).										
setDominion(Board,_,_,_,_,Board).
											
											











/*
:-include('Board.pl').
:-include('Player.pl').	
*/