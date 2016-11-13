/************************
*		BOARD			*
************************/

:-include('Matrix.pl').
:-include('Cell.pl').


/*
board
Type of board
*/			 
		 
board(1,[[0,[1,-1,0],[5,-1,0],[2,-1,0],[0,-1,0]],		%SMALL		
		 [[4,-1,0],[6,0,4],[3,-1,0],[7,-1,0],[3,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[4,-1,0],[1,-1,0]],
		 [[7,-1,0],[2,-1,0],[5,-1,0],[6,2,4],[0,-1,0]],
		 [0,[3,-1,0],[5,-1,0],[0,-1,0],[4,-1,0]]]).
		 
board(2,[[0,[1,-1,0],[0,-1,0],[2,-1,0],[4,-1,0],[3,-1,0],[0,-1,0],[1,-1,0]],		%MEDIUM
		 [[0,-1,0],[6,0,4],[3,-1,0],[7,-1,0],[0,-1,0],[0,-1,0],[2,-1,0],[5,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[0,-1,0],[3,-1,0],[2,-1,0],[4,-1,0],[1,-1,0]],
		 [[7,-1,0],[2,-1,0],[0,-1,0],[1,-1,0],[0,-1,0],[7,-1,0],[0,-1,0],[3,-1,0]],
		 [0,[3,-1,0],[4,-1,0],[0,-1,0],[5,-1,0],[2,-1,0],[1,-1,0],[3,-1,0]],
		 [[5,-1,0],[7,-1,0],[3,-1,0],[7,-1,0],[0,-1,0],[3,-1,0],[6,2,4],[2,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[0,-1,0],[1,-1,0],[3,-1,0],[0,-1,0],[1,-1,0]]]).
		 
board(3,[[0,[1,-1,0],[0,-1,0],[2,-1,0],[7,-1,0],[3,-1,0],[5,-1,0],[3,-1,0],[0,-1,0],[2,-1,0]],		%BIG		
		 [[0,-1,0],[6,0,4],[3,-1,0],[1,-1,0],[3,-1,0],[4,-1,0],[3,-1,0],[7,-1,0],[0,-1,0],[0,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[0,-1,0],[1,-1,0],[7,-1,0],[3,-1,0],[2,-1,0],[0,-1,0],[0,-1,0]],
		 [[7,-1,0],[2,-1,0],[0,-1,0],[1,-1,0],[0,-1,0],[3,-1,0],[1,-1,0],[0,-1,0],[7,-1,0],[1,-1,0]],
		 [0,[3,-1,0],[0,-1,0],[7,-1,0],[0,-1,0],[0,-1,0],[5,-1,0],[3,-1,0],[2,-1,0],[4,-1,0]],
		 [[0,-1,0],[4,-1,0],[3,-1,0],[0,-1,0],[2,-1,0],[3,-1,0],[7,-1,0],[1,-1,0],[0,-1,0],[3,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[0,-1,0],[1,-1,0],[3,-1,0],[3,-1,0],[3,-1,0],[2,-1,0],[0,-1,0]],
		 [[0,-1,0],[7,-1,0],[0,-1,0],[1,-1,0],[0,-1,0],[7,-1,0],[0,-1,0],[3,-1,0],[6,2,4],[3,-1,0]],
		 [0,[3,-1,0],[0,-1,0],[3,-1,0],[5,-1,0],[3,-1,0],[2,-1,0],[3,-1,0],[1,-1,0],[0,-1,0]]]).
		 
board(4,[[0,[1,1,0],[5,2,1],[2,0,1],[0,3,0]],			%FINAL_OCUPADO_EXEMPLO
		 [[4,2,1],[6,0,0],[3,2,0],[7,-1,0],[3,3,2]],
		 [0,[2,3,0],[0,1,0],[4,0,1],[1,1,0]],
		 [[7,-1,0],[2,0,1],[5,2,0],[6,2,0],[4,2,0]],
		 [0,[3,0,0],[5,1,1],[0,0,0],[4,3,0]]]).
		 				
board(5,[[0,[1,2,0],[5,3,0],[2,0,1],[0,2,1]],			%FINAL_ENCURRALADO_EXEMPLO
		 [[4,2,1],[6,0,0],[3,0,0],[7,-1,0],[3,2,1]],
		 [0,[2,1,0],[0,0,0],[4,0,1],[1,0,1]],
		 [[7,-1,0],[2,2,0],[5,2,0],[6,2,0],[4,3,1]],
		 [0,[3,-1,0],[5,-1,0],[0,-1,0],[4,-1,0]]]).
		 
board(6,[[0,[1,-1,0],[5,-1,0],[2,-1,0],[0,-1,0]],		%TESTEINES_EXEMPLO
		 [[4,0,1],[6,0,4],[3,0,1],[7,-1,0],[3,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[4,-1,0],[1,2,1]],
		 [[7,-1,0],[2,-1,0],[5,2,1],[6,2,4],[4,-1,0]],
		 [0,[3,-1,0],[5,-1,0],[0,-1,0],[4,-1,0]]]).

/*
displayBoard (board)
*/
 
displayBoard(I) :- board(I,S) , displayBoard(S).
displayBoard([L1|L2]) :- nl, write('     '), displayColumnN(L1,1), write('  ') ,displayTopLine(L1), displayMatrix2D([L1|L2],1).

displayMatrix2D([],_) :- nl .
displayMatrix2D([L1|L2],Row) :- displayLine(L1,Row),nl, Row1 is Row + 1,displayMatrix2D(L2,Row1).

displayLine([L1|L2],Row) :- write('  '),displayLine1([L1|L2]), write(' '),write(Row),displayLine2([L1|L2]), 
							write('  '),displayLine3([L1|L2]),write('  '),displayBottomLine([L1|L2]).	%LINE
							
displayColumnN([],_) :-	nl, nl.					
displayColumnN([_|E2],C) :- write(C),write('   '), C1 is C + 1, displayColumnN(E2,C1).				%COLUMN_NUMBERS

displayTopLine([]):- nl.
displayTopLine([E1|E2]) :- ((E1 == 0 , write('  ')); write(' / \\')),displayTopLine(E2).			%TOP_LINE_LIMIT

displayLine1([]):- write('|'),nl.	
displayLine1([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo1(E1)),displayLine1(E2).				%LINE_INFO_1
	
displayLine2([]):- write('|'),nl.
displayLine2([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo2(E1)),displayLine2(E2).				%LINE_INFO_2

displayLine3([]):- write('|'),nl.
displayLine3([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo3(E1)),displayLine3(E2).				%LINE_INFO_3

displayBottomLine([]):- write(' \\').
displayBottomLine([E1|E2]) :- ((E1 == 0 , write(' /'));write(' \\ /')),displayBottomLine(E2).		%BOTTOM_LINE_LIMIT

displayInfo1([IDs|_]) :- systemType(IDs,_,_), write('|'), displaySystem(IDs).
displayInfo2([IDs|[IDp|[N|[]]]]) :- systemType(IDs,_,_), dominion(IDp,_,_), write('| '),((N == 0, write('  '));(write(N), write(' '))).
displayInfo3([IDs|[IDp|[_|[]]]]) :- systemType(IDs,_,_), dominion(IDp,_,_), write('|'),displayDominion(IDp).

/*
getBoardCell  (board)
Returns the element in the row and Column of the Board
If the element is 0 it doesn't count as a column
*/
getBoardCell(Board,Row,Column,Cell) :- getCell(Board,Row,1,X), X == 0 ,!,NewColumn is Column + 1, getCell(Board,Row,NewColumn,Cell).
getBoardCell(Board,Row,Column,Cell) :- getCell(Board,Row,Column,Cell).

/*
setBoardCell  (board)
Returns a new Board where the element in Row and Column is Cell
If the element is 0 it doesn't count as a column
*/
setBoardCell(BoardI,Row,Column,Cell,BoardF) :- getCell(BoardI,Row,1,X), X == 0 ,!, NewColumn is Column+1,setCellValue(BoardI,Row,NewColumn,Cell,BoardF).
setBoardCell(BoardI,Row,Column,Cell,BoardF) :- setCellValue(BoardI,Row,Column,Cell,BoardF).


/*
getCellInDirection  (board)
Returns the adjacent Cell of (Ri,Ci) in a direction and the (Rf,Cf)
  |1| |2|
|3| |x| |4| Numbers - directions from cell 'x'
  |5| |6|
 */
 
getCellInDirection(Board,RowI,ColumnI,1,RowF,ColumnF,Cell) :- directionAux(Board,RowI,ColumnI,-1,-1,RowF,ColumnF), getBoardCell(Board,RowF,ColumnF,Cell).	%GET_CELL_IN_DIRECTION
getCellInDirection(Board,RowI,ColumnI,2,RowF,ColumnF,Cell) :- directionAux(Board,RowI,ColumnI,-1,1,RowF,ColumnF), getBoardCell(Board,RowF,ColumnF,Cell).
getCellInDirection(Board,RowI,ColumnI,3,RowI,ColumnF,Cell) :- ColumnF is ColumnI-1, getBoardCell(Board,RowI,ColumnF,Cell).
getCellInDirection(Board,RowI,ColumnI,4,RowI,ColumnF,Cell)	:- ColumnF is ColumnI+1, getBoardCell(Board,RowI,ColumnF,Cell).
getCellInDirection(Board,RowI,ColumnI,5,RowF,ColumnF,Cell)	:- directionAux(Board,RowI,ColumnI,1,-1,RowF,ColumnF), getBoardCell(Board,RowF,ColumnF,Cell).
getCellInDirection(Board,RowI,ColumnI,6,RowF,ColumnF,Cell)	:- directionAux(Board,RowI,ColumnI,1,1,RowF,ColumnF), getBoardCell(Board,RowF,ColumnF,Cell).

directionAux(Board,RowI,ColumnI,Rinc,Cinc,RowF,ColumnF) :- 	getCell(Board,RowI,1,0),!,
															((Cinc is -1, ColumnF is ColumnI);
															(ColumnF is ColumnI + 1)),
															RowF is RowI + Rinc,
															(ColumnF > 0) , (RowF > 0).
													
directionAux(_,RowI,ColumnI,Rinc,Cinc,RowF,ColumnF) :- 	((Cinc is -1, ColumnF is ColumnI - 1);
														ColumnF is ColumnI ),
														RowF is RowI + Rinc,
														(ColumnF > 0) , (RowF > 0).
											
/*
freeCellInDirection  (board)
Returns the next free position in a direction from the inicial row and column
It can overpass Cells dominated by Team
*/									
freeCellInDirection(Board,Team,RowI,ColumnI,Direction,RowF,ColumnF) :-	 getCellInDirection(Board,RowI,ColumnI,Direction,RowT,ColumnT,Cell), !,	%GET_FREE_CELL_IN_DIRECTION
																	(	(getCellDominion(Cell,-1) , getCellSystem(Cell,System),System \= 7, RowF is RowT, ColumnF is ColumnT);		
																		(getCellTeam(Cell,Team) , freeCellInDirection(Board,Team,RowT,ColumnT,Direction,RowF,ColumnF))).
	

	
/*
getAdjCells  (board)
Given an inicial Row and Column it returns a List F of the adjacent Cells
*/										
getAdjCells(BoardI,Row,Column,BoardF)	:- 	adjCellsAux(BoardI,Row,Column,1,[],T1), !,												%GET_ADJ_CELLS
											adjCellsAux(BoardI,Row,Column,2,T1,T2), !,
											adjCellsAux(BoardI,Row,Column,3,T2,T3), !,
											adjCellsAux(BoardI,Row,Column,4,T3,T4), !,						
											adjCellsAux(BoardI,Row,Column,5,T4,T5), !,
											adjCellsAux(BoardI,Row,Column,6,T5,BoardF).



adjCellsAux(BoardI,Row,Column,Direction,T,BoardF) :- 	getCellInDirection(BoardI,Row,Column,Direction,Rf,Cf,_), !,
														append(T,[[Rf|Cf]|[]],BoardF).								
adjCellsAux(_,_,_,_,T,T).
		

/*
getAdjFreeCells  (board)
Returns F a list of all the free adjecent Cells from R and C until the board's limits
*/
getAdjFreeCells(Board,Row,Column,Team,Cells) :- 	getAdjFreeCellsAux(Board,Row,Column,1,Team,[],T1), !,										%GET_ADJ_FREE_CELLS
													getAdjFreeCellsAux(Board,Row,Column,2,Team,T1,T2), !,
													getAdjFreeCellsAux(Board,Row,Column,3,Team,T2,T3), !,
													getAdjFreeCellsAux(Board,Row,Column,4,Team,T3,T4), !,
													getAdjFreeCellsAux(Board,Row,Column,5,Team,T4,T5), !,
													getAdjFreeCellsAux(Board,Row,Column,6,Team,T5,Cells).

getAdjFreeCellsAux(Board,Row,Column,Direction,Team,Tmp,Cells) :- 	getAllFreeCellsInDirection(Board,Row,Column,Direction,Team,[],Tmp2), 
																	append(Tmp,Tmp2,Cells).
										

getAllFreeCellsInDirection(Board,Row,Column,Direction,Team,Tmp,Cells) :- 	freeCellInDirection(Board,Team,Row,Column,Direction,Rf,Cf), !,
																			append(Tmp,[[Rf|[Cf|[]]]|[]],Tmp2),
																			getAllFreeCellsInDirection(Board,Rf,Cf,Direction,Team,Tmp2,Cells).
getAllFreeCellsInDirection(_,_,_,_,_,Cells,Cells).	
									