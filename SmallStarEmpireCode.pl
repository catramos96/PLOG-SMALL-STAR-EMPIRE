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

/*CELL*/

player(-1,' ',' ').
player(0,1,'C').
player(1,1,'T').
player(2,2,'C').
player(3,2,'T').

displayPlayer(I) :- player(I,P,C), write(P), write(C).

systemType(0,'S',0).		%empty
systemType(1,'S',1).		%OnePlanet
systemType(2,'S',2).		%TwoPlanet
systemType(3,'S',3).		%ThreePlanet
systemType(4,'N','R').		%NebulaRed
systemType(5,'N','B').		%NebulaBlue
systemType(6,'H',' ').		%HomeWorld
systemType(7,'B',' ').		%BlackHole

displaySystem(I) :- systemType(I,A,B),write(A),write(B).

/*Board*/

boardInfo(I) :- board(I,M),
			 nl, write('=============== BOARD INFO ==============='), nl, nl,
			 write('Cell(Type,Prop,Team,Aloc,NShips)'), nl,nl,
			 write('Type:  (H) - HomeBase  (S) - Star System  (N) - Nebula System  (B) - Blackhole  (W) - Whormhole'), nl,
			 write('Properties:  0-4 - Planets  (R)/(B) - Color'), nl,
			 write('Team:  (R)- Red  (B) - Blue'), nl,
			 write('Alocated:  (C) - Colony  (T) Trade Center'), nl,
			 write('NShips: 1-4'),nl,nl,nl.

/*ESTADO INICIAL*/
board(1,[[0,[1,-1,0],[5,-1,0],[2,-1,0],[0,-1,0]],			
		 [[4,-1,0],[6,0,4],[3,-1,0],[7,-1,0],[3,-1,0]],
		 [0,[2,-1,0],[0,-1,0],[4,-1,0],[1,-1,0]],
		 [[7,-1,0],[2,-1,0],[5,-1,0],[6,2,4],[4,-1,0]],
		 [0,[3,-1,0],[5,-1,0],[0,-1,0],[4,-1,0]]]).
		 
/*ESTADO FINAL TUDO OCUPADO*/
board(2,[[0,[1,1,0],[5,2,1],[2,0,1],[0,3,0]],		
		 [[4,2,1],[6,0,0],[3,2,0],[7,-1,0],[3,3,2]],
		 [0,[2,3,0],[0,1,0],[4,0,1],[1,1,0]],
		 [[7,-1,0],[2,0,1],[5,2,0],[6,2,0],[4,2,0]],
		 [0,[3,0,0],[5,1,1],[0,0,0],[4,3,0]]]).
		 
/*ESTADO FINAL ENCURRALADO FALTA FAZER*/
board(3,[[0,[1,2,0],[5,3,0],[2,0,1],[0,2,1]],			
		 [[4,2,1],[6,0,0],[3,0,0],[7,-1,0],[3,2,1]],
		 [0,[2,1,0],[0,0,0],[4,0,1],[1,0,1]],
		 [[7,-1,0],[2,2,0],[5,2,0],[6,2,0],[4,3,1]],
		 [0,[3,-1,0],[5,-1,0],[0,-1,0],[4,-1,0]]]).
		 
displayBoard(I) :- board(I,[L1|L2]), boardInfo(I), displayTopLine(L1), displayMatrix2D([L1|L2]).

displayMatrix2D([L1|L2]) :- displayLine(L1),nl,
							displayMatrix2D(L2).
				
displayMatrix2D([]) :- nl.

displayLine([L1|L2]) :- displayLine1([L1|L2]), displayLine2([L1|L2]), displayBottomLine([L1|L2]).


/*BoardLine Composition*/
displayTopLine([E1|E2]) :- ((E1 == 0 , write('  ')); write(' / \\')),displayTopLine(E2).
displayTopLine([]):- nl.

displayLine1([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo1(E1)),displayLine1(E2).
displayLine1([]):- write('|'),nl.	
	
displayLine2([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo2(E1)),displayLine2(E2).
displayLine2([]):- write('|'),nl.

displayBottomLine([E1|E2]) :- ((E1 == 0 , write(' /'));write(' \\ /')),displayBottomLine(E2).
displayBottomLine([]):- write(' \\').

/*Info per Line*/
displayInfo1([IDs|L]) :- systemType(IDs,A,B),
				write('|'), displaySystem(IDs), write(' ').

displayInfo2([IDs|[IDp|[N|[]]]]) :- systemType(IDs,A,B), player(IDp,C,D),
				write('|'),displayPlayer(IDp),(N == 0, write(' ');write(N)).

displayCell([IDs|[IDp|[N|[]]]]) :- systemType(IDs,A,B), player(IDp,C,D), displaySystem(IDs),write(','),displayPlayer(IDp),write(','),write(N).

/*Se a linha da matriz começar com 0 então o elemento da coluna x vai ser na verdade o da coluna x+1*/
getBoardCell(I,R,C,V) :- board(I,S) , ((getCell(S,R,1,X) , X == 0 , C1 is C + 1 , getCell(S,R,C1,V)) ; getCell(S,R,C,V)), displayCell(V).

%player(NOME,LISTROWS,LISTCOLLUMNS,cleft,tleft).