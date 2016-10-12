/*INFO*/

load :- use_module(library(lists)). /* Necessario chamar no principio*/

help :- 	nl, write('=============== HELP ==============='), nl,nl, 
			write('=============== CELL ==============='), nl,
			write('cell(Id,Type,Color/NrPlanets,Trade/Colony,Team,NrShips)'), nl, 
			write('displayCell(Id)'), nl, nl,
			write('=============== BOARD ==============='), nl, 
			write('board(Id,Matrix)'), nl,
			write('boardInfo(Id)'),nl,
			write('displayBoard(Id)'), nl,
			write('getBoardCell(Id,i,j,value)'), nl, nl.
	
/*MATRIX*/

getCell(Mat,Row,Column,Value) :- nth1(Row, Mat, ARow), nth1(Column, ARow, Value).
	
/*CELLS*/	

cell(1,'S',4,'_','_',0).		%starSystem
cell(2,'W','x','x','x','x').	%whormhole
cell(3,'B','x','x','x','x').	%blackhole
cell(4,'S',1,'_','_',0).		%starSystem
cell(5,'N','R','_','_',0).		%nebula


cell(6,'H','x','R','x','0').		/*Home base */
cell(7,'H','x','B','x','0').

displayCell(A) :- cell(A,B,C,D,E,F),
				write(B), write(C), write(D), write(E), write(F).

/*Board*/

boardInfo(I) :- board(I,M),
			 nl, write('=============== BOARD INFO ==============='), nl, nl,
			 write('Cell(Type,Prop,Team,Aloc,NShips)'), nl,nl,
			 write('Type:  (H) - HomeBase  (S) - Star System  (N) - Nebula System  (B) - Blackhole  (W) - Whormhole'), nl,
			 write('Properties:  0-4 - Planets  (R)/(B) - Color'), nl,
			 write('Team:  (R)- Read  (B) - Blue'), nl,
			 write('Alocated:  (C) - Colony  (T) Trade Center'), nl,
			 write('NShips: 1-4'),nl,
			 write('_ - can be set to a value'), nl,
			 write('x - can not have a value'), nl,nl,nl.

board(1,[[0,1,0,2,0,3,0,4,0,0,0,0,0,0,0],				/*board2players (15x9) - IDs of cells*/
		 [4,0,6,0,5,0,2,0,1,0,3,0,4,0,0],
		 [0,5,0,4,0,3,0,2,0,1,0,5,0,2,0],
		 [1,0,3,0,2,0,5,0,4,0,2,0,1,0,0],
		 [0,2,0,5,0,3,0,2,0,1,0,5,0,4,0],
		 [0,0,1,0,4,0,5,0,2,0,1,0,3,0,5],
		 [0,3,0,2,0,1,0,2,0,5,0,2,0,1,0],
		 [0,0,0,0,0,0,4,0,1,0,3,0,7,0,2],
		 [0,0,0,0,0,0,0,5,0,2,0,4,0,5,0]]).
		 
displayBoard(I) :- board(I,S), boardInfo(I), displayMatrix2D(S).

displayMatrix2D([L1|L2]) :- displayLine(L1), nl,
							displayMatrix2D(L2).
				
displayMatrix2D([]) :- nl.

displayLine([E1|E2]) :- ((E1 == 0 , write('       '));(write('|'),displayCell(E1),write('|'))), displayLine(E2).

displayLine([]):- nl.	

/*As linhas e colunas começam com índice 1*/

getBoardCell(I,R,C,V) :- board(I,S) , getCell(S,R,C,V), displayCell(V).		

/*PLAYERS*/

player(R,[],[]).
player(B,[],[]).