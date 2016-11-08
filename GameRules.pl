/************************
*		GAME RULES		*
************************/			

placeShip(Board,Row,Column,ShipsAdd,Final) :- 		getBoardCell(Board,Row,Column,[SystemId|[DominionId|[Ships|[]]]]) ,
													NewShips is Ships+ShipsAdd,
													setBoardCell(Board,Row,Column,[SystemId|[DominionId|[NewShips|[]]]],Final).															
placeShip(Board,_,_,_,_,Board).

placeControl(Board,Team,Row,Column,Type,Final) :-	getBoardCell(Board,Row,Column,[SystemId|[-1|S]]) ,
													dominion(NewDominionId,Team,Type),
													setBoardCell(Board,Row,Column,[SystemId|[NewDominionId|S]],Final).													
placeControl(Board,_,_,_,_,Board).

%CONFIRMATION												
hasShip(Pi,Row,Column,1) :- 	playerGetShips(Pi,S),
								member([Row|Column],S).										
hasShip(_,_,_,_,0).
											
validMove(Board,Pi,Ri,Ci,Rf,Cf,1) :- 	hasShip(Pi,Ri,Ci,1),!,		/*ship to move?*/	
										getBoardCell(Board,Rf,Cf,[_|[DominionId|_]]) ,
										playerGetTeam(Pi,Team),
										(dominion(DominionId,Team,_) ; (DominionId is -1)).											
validMove(_,_,_,_,0).	

hasControl(Board,Row,Column,0) :- getBoardCell(Board,Row,Column,[_|[-1|[0|[]]]]).
hasControl(_,_,_,1).	

/*
:-include('Board.pl').
:-include('Player.pl').	
*/