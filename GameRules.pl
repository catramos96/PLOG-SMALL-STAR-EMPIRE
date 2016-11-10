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
													setBoardCell(Board,Row,Column,NewCell,Final), displayBoard(Final).												
setDominion(Board,_,_,_,_,Board).

%CONFIRMATION												
hasShip(Pi,Row,Column,1) :- 	playerGetShips(Pi,S),
								member([Row|Column],S).										
hasShip(_,_,_,_,0).
											
validMove(Board,Pi,Ri,Ci,Rf,Cf,1) :- 	hasShip(Pi,Ri,Ci,1).
										
										

testMove(Board,Team,Ri,Ci,Rf,Cf,Direction).


validMove(_,_,_,_,0).	

hasControl(Board,Row,Column,0) :- getBoardCell(Board,Row,Column,Cell), getCellDominion(Cell,-1).
hasControl(_,_,_,1).	



/*
:-include('Board.pl').
:-include('Player.pl').	
*/