/****************************************
*		Game Functionalities Aux		*
****************************************/

:-include('Bot.pl').
		
/*
getPossibleMoves
Creates a matrix where each row (i) represents a PlayerI'Ship ship (in the position i of playerGetShips)
Each row is a list of possible moves for a ship.
*/
getPossibleMoves(Board,PlayerI,AllMoves) :- playerGetShips(PlayerI,Ships), playerGetTeam(PlayerI,Team),
											possibleMovesAux(Board,Team,Ships,[],AllMoves).

possibleMovesAux(Board,Team,[Ship|Sn],T,AllMoves) :- 	getPosition(Ship,Row,Column),nl,getAdjFreeCells(Board,Row,Column,Team,Cells),
														append(T,[Cells|[]],T1), possibleMovesAux(Board,Team,Sn,T1,AllMoves).
possibleMovesAux(_,_,_,AllMoves,AllMoves).

/*
validMove
True if the [Ri,Ci] is a position of a ship
and if [Rf,Cf] is in the list of possible moves for that ship
*/																				
validMove(AllMoves,PlayerI,RowI,ColumnI,RowF,ColumnF) :- 	playerGetShips(PlayerI,Ships),				/*Get Ships*/
															getListElem(Ships,Position,[RowI|[ColumnI|[]]]),	/*Get Position of Ship*/
															getListElem(AllMoves,Position,ShipsMoves),			/*Get Move for Ship Position*/
															getListElem(ShipsMoves,_,[RowF|[ColumnF|[]]]).	/*Check if the final Position is in the possibles moves list*/
																	
validMove(_,_,_,_,_,_) :- 	error(1), fail.

/*
updateValidShips
removes the ships that have no longer possible moves
*/
updateValidShips(Board,PlayerI,PlayerF) :- playerGetShips(PlayerI,Ships),validShips(Board,PlayerI,Ships,PlayerF).		

validShips(_,P,[],P).
validShips(Board,PlayerI,[Ship|Sn],PlayerF) :- 	getPosition(Ship,Row,Column), playerGetTeam(PlayerI,Team),
												getAdjFreeCells(Board,Row,Column,Team,[]), !,
												playerRemShip(PlayerI,Ship,PlayerT), validShips(Board,PlayerT,Sn,PlayerF).
validShips(Board,PlayerI,[_|Sn],PlayerF) :- 	validShips(Board,PlayerI,Sn,PlayerF).


/*
setShip
Sets a ship on the Row and Column of a Board, returns BoardF the changed board.
If ShipsAdd 1, it increments a ship.
If ShipsAdd -2, it decrements a ship.
*/
setShip(Board,Row,Column,ShipsAdd,Final) :- 		getBoardCell(Board,Row,Column,Cell),									%SET_SHIP
													(	(ShipsAdd is 1 , incCellShips(Cell,NewCell));
														(ShipsAdd is -1, decCellShips(Cell,NewCell))	),
													getCellShips(NewCell,NewShips), NewShips > -1,
													setBoardCell(Board,Row,Column,NewCell,Final).

													
/*
setDominion
Sets the dominion on the Row and Column Cof a board, returns BoardF the changed board.
*/												
setDominion(Board,Team,Row,Column,Type,Final) :-	getBoardCell(Board,Row,Column,Cell),									%SET_DOMINION
													getCellDominion(Cell,-1), !,
													dominion(Id,Team,Type), !,
													setCellDominion(Cell,Id,NewCell), !,
													setBoardCell(Board,Row,Column,NewCell,Final).

