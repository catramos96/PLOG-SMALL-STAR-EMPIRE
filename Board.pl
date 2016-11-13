/************************
*		BOARD			*
************************/

:-include('Matrix.pl').

boardInfo :-
			 nl, write('=============== BOARD INFO ==============='), nl, nl,
			 write(' --------------- '),nl,
			 write('| Type Property |'),nl,
			 write('|               |'),nl,
			 write('|Team Aloc Ships|'),nl,
			 write(' --------------- '),nl,
			 write('Cell(Type,Prop,Team,Aloc,NShips)'), nl,nl,
			 write('Type:  (H) - HomeBase  (S) - Star System  (N) - Nebula System  (B) - Blackhole  (W) - Whormhole'), nl,
			 write('Properties:  0-3 - Planets  (R)/(B) - Color'), nl,
			 write('Team:  (1)- Red team  (2) - Blue team'), nl,
			 write('Alocated:  (C) - Colony  (T) Trade Center'), nl,
			 write('NShips: 1-4'),nl,nl,nl .

%TYPES
		 
board(1,[[0,[1,-1,0],[5,-1,0],[2,-1,0],[0,-1,0]],		%INICIAL		
		 [[4,-1,0],[6,0,4],[3,-1,0],[7,-1,0],[3,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[4,-1,0],[1,-1,0]],
		 [[7,-1,0],[2,-1,0],[5,-1,0],[6,2,4],[4,-1,0]],
		 [0,[3,-1,0],[5,-1,0],[0,-1,0],[4,-1,0]]]).
		 
board(2,[[0,[1,1,0],[5,2,1],[2,0,1],[0,3,0]],			%FINAL_OCUPADO		
		 [[4,2,1],[6,0,0],[3,2,0],[7,-1,0],[3,3,2]],
		 [0,[2,3,0],[0,1,0],[4,0,1],[1,1,0]],
		 [[7,-1,0],[2,0,1],[5,2,0],[6,2,0],[4,2,0]],
		 [0,[3,0,0],[5,1,1],[0,0,0],[4,3,0]]]).
		 				
board(3,[[0,[1,2,0],[5,3,0],[2,0,1],[0,2,1]],			%FINAL_ENCURRALADO
		 [[4,2,1],[6,0,0],[3,0,0],[7,-1,0],[3,2,1]],
		 [0,[2,1,0],[0,0,0],[4,0,1],[1,0,1]],
		 [[7,-1,0],[2,2,0],[5,2,0],[6,2,0],[4,3,1]],
		 [0,[3,-1,0],[5,-1,0],[0,-1,0],[4,-1,0]]]).
		 
board(4,[[0,[1,-1,0],[5,-1,0],[2,-1,0],[0,-1,0]],		%TESTEINES		
		 [[4,0,1],[6,0,4],[3,0,1],[7,-1,0],[3,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[4,-1,0],[1,2,1]],
		 [[7,-1,0],[2,-1,0],[5,2,1],[6,2,4],[4,-1,0]],
		 [0,[3,-1,0],[5,-1,0],[0,-1,0],[4,-1,0]]]).

%DISPLAYS	

 
displayBoard(I) :- board(I,S) , displayBoard(S).
displayBoard([L1|L2]) :- nl, displayTopLine(L1), displayMatrix2D([L1|L2]).

displayMatrix2D([]) :- nl .
displayMatrix2D([L1|L2]) :- displayLine(L1),nl, displayMatrix2D(L2).

displayLine([L1|L2]) :- displayLine1([L1|L2]), displayLine2([L1|L2]), displayLine3([L1|L2]),displayBottomLine([L1|L2]).	%LINE

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
displayInfo3([IDs|[IDp|[N|[]]]]) :- systemType(IDs,_,_), dominion(IDp,_,_), write('|'),displayDominion(IDp).

%GETS
getBoardCell(B,R,C,V) :- getCell(B,R,1,X), X == 0 ,!,C1 is C + 1, getCell(B,R,C1,V).
getBoardCell(B,R,C,V) :- getCell(B,R,C,V).

%SETS
setBoardCell(B,R,C,V,F) :- getCell(B,R,1,X), X == 0 ,!, C1 is C+1,setCellValue(B,R,C1,V,F).
setBoardCell(B,R,C,V,F) :- setCellValue(B,R,C,V,F).

%CONFIRMATION

isBoardEmpty(B,0) :- member(B,X),member(X,[_,-1,0]).
isBoardEmpty(_,1).

isCellFree(Board,Row,Column) :- getBoardCell(Board,Row,Column,Cell), getCellDominion(Cell,-1).

/*Returns the adjacent Cell of (Ri,Rf) in a direction
  |1| |2|
|3| |x| |4| Numbers - directions from cell 'x'
  |5| |6|
 */
 
getCellInDirection(B,Ri,Ci,1,Rf,Cf,Cell) :- directionAux(B,Ri,Ci,-1,-1,Rf,Cf), getBoardCell(B,Rf,Cf,Cell).	%GET_CELL_IN_DIRECTION
getCellInDirection(B,Ri,Ci,2,Rf,Cf,Cell) :- directionAux(B,Ri,Ci,-1,1,Rf,Cf), getBoardCell(B,Rf,Cf,Cell).
getCellInDirection(B,Ri,Ci,3,Ri,Cf,Cell) :- Cf is Ci-1, getBoardCell(B,Ri,Cf,Cell).
getCellInDirection(B,Ri,Ci,4,Ri,Cf,Cell)	:- Cf is Ci+1, getBoardCell(B,Ri,Cf,Cell).
getCellInDirection(B,Ri,Ci,5,Rf,Cf,Cell)	:- directionAux(B,Ri,Ci,1,-1,Rf,Cf), getBoardCell(B,Rf,Cf,Cell).
getCellInDirection(B,Ri,Ci,6,Rf,Cf,Cell)	:- directionAux(B,Ri,Ci,1,1,Rf,Cf), getBoardCell(B,Rf,Cf,Cell).

directionAux(B,Ri,Ci,Rinc,Cinc,Rf,Cf) :- 	getCell(B,Ri,1,0),!,
											((Cinc is -1, Cf is Ci);
											(Cf is Ci + 1)),
											Rf is Ri + Rinc,
											(Cf > 0) , (Rf > 0).
													
directionAux(_,Ri,Ci,Rinc,Cinc,Rf,Cf) :- 	((Cinc is -1, Cf is Ci - 1);
											Cf is Ci ),
											Rf is Ri + Rinc,
											(Cf > 0) , (Rf > 0).
											
/*Returns the next free position in a direction from the inicial row and column*/									
freeCellInDirection(B,T,Ri,Ci,D,Rf,Cf) :-	 getCellInDirection(B,Ri,Ci,D,Rt,Ct,Cell), !,					%GET_FREE_CELL_IN_DIRECTION
										(	(getCellDominion(Cell,-1) , getCellSystem(Cell,System),System \= 7, Rf is Rt, Cf is Ct);			
											(getCellTeam(Cell,T) , freeCellInDirection(B,T,Rt,Ct,D,Rf,Cf))).
	
/*Given an inicial Row and a Column and the final Row and Column it returns the APROXIMATION direction that the movement takes*/
getCellDirection(Board,Ri,Ci,Rf,Cf,D) :-	getCellDirectionAux(Board,Ri,Cinc), (							%GET_FINAL_POSITION_DIRECTION
											 (Rf < Ri, (
														((Cf =< Ci - 1 + Cinc), D is 1) ; 
														(Cf >= Ci + Cinc, D is 2)
														)
											);
											 (Rf is Ri,(
														(Cf < Ci, D is 3) ; 
														(Cf > Ci, D is 4)	
														)
											);
											 (Rf > Ri, (
														((Cf =< Ci - 1 + Cinc), D is 5) ; 
														((Cf >= Ci + Cinc), D is 6)
														)
											)
											).
	
getCellDirectionAux(Board,Ri,1) :-	getCell(Board,Ri,1,0).
getCellDirectionAux(_,_,0).
	
/*Given an inicial Row and Column it returns a List F of the adjacent Cells*/										
getAdjCells(B,Ri,Ci,F)	:- 	adjCellsAux(B,Ri,Ci,1,[],T1), !,												%GET_ADJ_CELLS
							adjCellsAux(B,Ri,Ci,2,T1,T2), !,
							adjCellsAux(B,Ri,Ci,3,T2,T3), !,
							adjCellsAux(B,Ri,Ci,4,T3,T4), !,						
							adjCellsAux(B,Ri,Ci,5,T4,T5), !,
							adjCellsAux(B,Ri,Ci,6,T5,F).



adjCellsAux(B,Ri,Ci,D,T,F) :- 	getCellInDirection(B,Ri,Ci,D,Rf,Cf,_), !,
								append(T,[[Rf|Cf]|[]],F).								
adjCellsAux(_,_,_,_,T,T).
		

										

/*===========================================

checkEmptyList([_|[-1|_]], Position, ListBefore, ListAfter) :- 	append(ListBefore,Position,ListAfter) .
checkEmptyList(_, _, List, List).						

getAllFreeCellsRow(Board,R,C,List,FinalList) :-	getBoardCell(Board,1,C,Value), !,
												checkEmptyList(Value,[[R|C]|[]],List,TempList),
												Cnext is C + 1,
												getAllFreeCellsRow(Board,R,Cnext,TempList,FinalList) .
getAllFreeCellsRow(_,_,_,List,List).

getAllFreeCells(_,[],_,_,List,List).
getAllFreeCells(Board,[A|B],R,C,List,FinalList) :-  getAllFreeCellsRow(Board,R,C,List,TempList), !,
													Rnext is R + 1,
													getAllFreeCells(Board,B,Rnext,1,TempList,FinalList) .*/

		/*Returns F a list of all the free adjecent Cells from R and C until the board's limits*/
getAdjFreeCells(B,R,C,T,F) :- 	getAdjFreeCellsAux(B,R,C,1,T,[],T1), !,										%GET_ADJ_FREE_CELLS
									getAdjFreeCellsAux(B,R,C,2,T,T1,T2), !,
									getAdjFreeCellsAux(B,R,C,3,T,T2,T3), !,
									getAdjFreeCellsAux(B,R,C,4,T,T3,T4), !,
									getAdjFreeCellsAux(B,R,C,5,T,T4,T5), !,
									getAdjFreeCellsAux(B,R,C,6,T,T5,F).

getAdjFreeCellsAux(B,R,C,D,T,Tmp,F) :- 	getAllFreeCellsInDirection(B,R,C,D,T,[],Tmp2), 
										append(Tmp,Tmp2,F).
										

getAllFreeCellsInDirection(B,R,C,D,T,Tmp,F) :- 	freeCellInDirection(B,T,R,C,D,Rf,Cf), !,
												append(Tmp,[[Rf|[Cf|[]]]|[]],Tmp2),
												getAllFreeCellsInDirection(B,Rf,Cf,D,T,Tmp2,F).
getAllFreeCellsInDirection(_,_,_,_,_,F,F).											
/************************
*		CELL			*
************************/

dominion(-1,' ',' ').		
dominion(0,1,'C').
dominion(1,1,'T').
dominion(2,2,'C').
dominion(3,2,'T').

systemType(0,'S',0).		%empty
systemType(1,'S',1).		%OnePlanet
systemType(2,'S',2).		%TwoPlanet
systemType(3,'S',3).		%ThreePlanet
systemType(4,'N','R').		%NebulaRed
systemType(5,'N','B').		%NebulaBlue
systemType(6,'H',' ').		%HomeWorld
systemType(7,'B',' ').		

%GETS
getCellSystem([St|[_|[_|[]]]],St) :- systemType(St,_,_).
getCellDominion([_|[D|[_|[]]]],D) :- dominion(D,_,_).
getCellShips([_|[_|[S|[]]]],S).
getCellTeam(Cell,Team) :- 	getCellDominion(Cell,D), dominion(D,Team,_).

%SETS
setCellSystem([_|[D|[S|[]]]],NewSt,[NewSt|[D|[S|[]]]]).
setCellDominion([St|[_|[S|[]]]],NewD,[St|[NewD|[S|[]]]]).
setCellShips([St|[D|[_|[]]]],NewS,[St|[D|[NewS|[]]]]).

%INC
incCellShips(Cell,NewCell) :- 	getCellShips(Cell,S),
								NewS is S + 1,
								setCellShips(Cell,NewS,NewCell).
	
%DEC	
decCellShips(Cell,NewCell) :- 	getCellShips(Cell,S),
								NewS is S - 1,
								setCellShips(Cell,NewS,NewCell).

%DISPLAY
displayDominion(I) :- dominion(I,P,C), write(P), write(' '),write(C).
displaySystem(I) :- systemType(I,A,B),write(A),write(' '),write(B).
displayCell([IDs|[IDp|[N|[]]]]) :- systemType(IDs,_,_), dominion(IDp,_,_), displaySystem(IDs),write(','),displayDominion(IDp),write(','),write(N).