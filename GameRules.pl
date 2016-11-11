/************************
*		GAME RULES		*
*************************
Rules related to game function
Validation of arguments
*/		

setShip(Board,Row,Column,ShipsAdd,Final) :- 		getBoardCell(Board,Row,Column,Cell),
													(	(ShipsAdd is 1 , incCellShips(Cell,NewCell));
														(ShipsAdd is -1, decCellShips(Cell,NewCell))	),
													getCellShips(NewCell,NewShips), NewShips > -1,
													setBoardCell(Board,Row,Column,NewCell,Final).													
setShip(Board,_,_,_,_,Board).

setDominion(Board,Team,Row,Column,Type,Final) :-	getBoardCell(Board,Row,Column,Cell),
													getCellDominion(Cell,-1),
													dominion(Id,Team,Type), setCellDominion(Cell,Id,NewCell),
													setBoardCell(Board,Row,Column,NewCell,Final).										
setDominion(Board,_,_,_,_,Board).

%CONFIRMATION												
hasShip(Pi,Row,Column) :- 	playerGetShips(Pi,S),
								member([Row|[Column|[]]],S).
											
validMove(Board,Pi,Ri,Ci,Rf,Cf) :- 	hasShip(Pi,Ri,Ci), !,
									isCellFree(Board,Rf,Cf),
									testMove(Board,Pi,Ri,Ci,Rf,Cf).
										
									

testMove(B,Pi,Ri,Ci,Rf,Cf) :- 	getCellDirection(B,Ri,Ci,Rf,Cf,D), !,	/*Get probable direction*/
								playerGetTeam(Pi,Team),
								testMoveAux(B,Team,Ri,Ci,Rf,Cf,D).

testMoveAux(B,T,Ri,Ci,Rf,Cf,D) :- 	getCellInDirection(B,Ri,Ci,D,Rt,Ct,NextCell), !,						/*Next cell in the direction D*/
									(getCellTeam(NextCell,' '); getCellTeam(NextCell,T)), !,			/*Checks if it's a valid cell*/
									(getCellSystem(NextCell,SType) , SType \= 7), !,						/*Not a BlackHole*/
									((Rt is Rf , Ct is Cf);												/*Final Cell ? */
									(getCellDirection(B,Rt,Ct,Rf,Cf,D),testMoveAux(B,T,Rt,Ct,Rf,Cf,D))).


isCellFree(Board,Row,Column) :- getBoardCell(Board,Row,Column,Cell), getCellDominion(Cell,-1).

updateValidShips(Board,Player,FinalPlayer) :- playerGetShips(Player,Ships),validShips(Board,Player,Ships,FinalPlayer).

validShips(_,P,[],P).
validShips(Board,Player,[S|Sn],FinalPlayer) :- 	getPosition(S,R,C), playerGetTeam(Player,Team), write('here'),
												getAdjFreeCells(Board,R,C,Team,[]), !,
												playerRemShip(Player,S,PlayerT), validShips(Board,PlayerT,Sn,FinalPlayer).
validShips(Board,Player,[_|Sn],FinalPlayer) :- 	validShips(Board,Player,Sn,FinalPlayer).
											
											











/*
:-include('Board.pl').
:-include('Player.pl').	
*/