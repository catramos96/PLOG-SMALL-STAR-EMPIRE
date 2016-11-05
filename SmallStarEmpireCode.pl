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


setCell([],_,_,_,_,_,F,F).
setCell([L1|L2],R,C,Nr,Nc,V,T,Mf) :- 	R is Nr, ! , setCellRow(L1,C,Nc,V,[],Rf),
										append(T,[Rf|[]],T2),
										Nr1 = Nr + 1,
										setCell(L2,R,C,Nr1,Nc,V,T2,Mf).										
setCell([L1|L2],R,C,Nr,Nc,V,T,Mf) :- 	setCellRow(L1,C,Nc,V,[],Rf),
										append(T,[L1|[]],T2),
										Nr1 = Nr + 1,
										setCell(L2,R,C,Nr1,Nc,V,T2,Mf).
										
setCellRow([],_,_,_,F,F).
setCellRow([L1|L2],C,Nc,V,T,F) :- 	C is Nc ,!, append(T,[V|[]],T2),
									Nc1 = Nc + 1,
									setCellRow(L2,C,Nc1,V,T2,F).
									
setCellRow([L1|L2],C,Nc,V,T,F) :- 	append(T,[L1|[]],T2),
									Nc1 = Nc + 1,
									setCellRow(L2,C,Nc1,V,T2,F).
		

displayM([]).
displayM([L1|L2]) :- displayRow(L1),nl, displayM(L2).		
displayRow([]).
displayRow([L1|L2]) :- write(L1),displayRow(L2).
								 

/*CELL*/

dominion(-1,' ',' ').
dominion(0,1,'C').
dominion(1,1,'T').
dominion(2,2,'C').
dominion(3,2,'T').

displayDominion(I) :- dominion(I,P,C), write(P), write(C).

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
board_settings(Board) :- 	write('BOARD SETTINGS'), nl,
							write('BoardsId (1): '), read(BoardId), 
							board(BoardId,Board),
							nl.

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
		 
displayBoard(I) :- board(I,[L1|L2]), displayTopLine(L1), displayMatrix2D([L1|L2]).
displayBoard([L1|L2]) :- nl, displayTopLine(L1), displayMatrix2D([L1|L2]).

displayMatrix2D([]) :- nl .
displayMatrix2D([L1|L2]) :- displayLine(L1),nl, displayMatrix2D(L2).

displayLine([L1|L2]) :- displayLine1([L1|L2]), displayLine2([L1|L2]), displayBottomLine([L1|L2]).

/*BoardLine Composition*/
displayTopLine([]):- nl.
displayTopLine([E1|E2]) :- ((E1 == 0 , write('  ')); write(' / \\')),displayTopLine(E2).

displayLine1([]):- write('|'),nl.	
displayLine1([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo1(E1)),displayLine1(E2).
	
displayLine2([]):- write('|'),nl.
displayLine2([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo2(E1)),displayLine2(E2).

displayBottomLine([]):- write(' \\').
displayBottomLine([E1|E2]) :- ((E1 == 0 , write(' /'));write(' \\ /')),displayBottomLine(E2).

/*Info per Line*/
displayInfo1([IDs|L]) :- systemType(IDs,A,B), write('|'), displaySystem(IDs), write(' ').
displayInfo2([IDs|[IDp|[N|[]]]]) :- systemType(IDs,A,B), dominion(IDp,C,D), write('|'),displayDominion(IDp),(N == 0, write(' ');write(N)).

/*GETS,SETS,DISPLAY*/

displayCell([IDs|[IDp|[N|[]]]]) :- systemType(IDs,A,B), dominion(IDp,C,D), displaySystem(IDs),write(','),displayDominion(IDp),write(','),write(N).

getBoardCell(B,R,C,V) :- getCell(B,R,1,X), X == 0 ,!,C1 is C + 1, getCell(B,R,C1,V).
getBoardCell(B,R,C,V) :- getCell(B,R,C,V).

setBoardCell(B,R,C,V,F) :- getCell(B,R,1,X), X == 0 ,!, C1 is C+1,setCell(B,R,C1,1,1,V,[],F).
setBoardCell(B,R,C,V,F) :- setCell(B,R,C,1,1,V,[],F).

/*
REGRAS JOGO
*/
placeShip(Board,Team,Row,Column,ShipsAdd,Final) :- 		getBoardCell(Board,Row,Column,[SystemId|[DominionId|[Ships|[]]]]) ,
														NewShips is Ships+ShipsAdd,
														setBoardCell(Board,Row,Column,[SystemId|[DominionId|[NewShips|[]]]],Final).
																
placeShip(Board,_,_,_,_,Board).

hasControl(Board,Row,Column,0) :- getBoardCell(Board,Row,Column,[SystemId|[-1|[0|[]]]]).

hasControl(_,_,_,1).

placeControl(Board,Team,Row,Column,Type,Final) :-	getBoardCell(Board,Row,Column,[SystemId|[-1|S]]) ,
													dominion(NewDominionId,Team,Type),
													setBoardCell(Board,Row,Column,[SystemId|[NewDominionId|S]],Final).
													
placeControl(Board,_,_,_,_,Board).
												
									
hasShip(Board,Team,Row,Column,1) :- 	getBoardCell(Board,Row,Column,[SystemId|[DominionId|[Ships|[]]]]),	/*Mesma equipa e com navios*/
											dominion(DominionId,Team,Type),
											Ships > 0.	
											
hasShip(_,_,_,_,0).
											
validMove(Board,Team,Row,Column,1) :- 	getBoardCell(Board,Row,Column,[_|[DominionId|_]]) ,
										dominion(DominionId,Team,_).
											
validMove(_,_,_,_,0).

/*PLAYER - Team , Ships , Trades, Colonies*/

player_settings(Name,Team) :- 	write('PLAYER SETTINGS'),nl,
								write('Name: '), read(Name),
								write('Team (1,2): '), read(Team),
								nl.
player(1,[],[],[]).
player(2,[],[],[]).												

addControl(Board,Team,Rf,Cf,Final) :- 	hasControl(Board,Rf,Cf,R2), R2 is 0, !,			/*has control?*/
										write('Colony(C) or Trade(T)'),	read(Type),
										placeControl(Board,Team,Rf,Cf,Type,Final).

addControl(Board,_,_,_,Board) :- write('No Control to add'), nl.									

moveShip_settings(Ri,Ci,Rf,Cf) :- 	write('From Row'), read(Ri),
									write('From Column'),read(Ci),
									write('To Row'), read(Rf),
									write('To Column'),read(Cf).
									
moveShip(Board,Team,FinalBoard) :- 	moveShip_settings(Ri,Ci,Rf,Cf),
									hasShip(Board,Team,Ri,Ci,R1), R1 is 1,!,		/*ship to move?*/								
									addControl(Board,Team,Rf,Cf,Tmp1),
									validMove(Tmp1,Team,Rf,Cf,R2), R2 is 1,!,
									placeShip(Tmp1,Team,Rf,Cf,1,Tmp2),
									placeShip(Tmp2,Team,Ri,Ci,-1,FinalBoard).
				
moveShip(Board,_,Board) :- 			write('Movimento invalido'), nl.
									
									
								
/*MAIN*/

clearscreen :- write('\e[2J').

settings(Board,Name,Team) :- 	load, clearscreen,
								board_settings(Board), 
								player_settings(Name,Team).

game :- clearscreen,
		settings(Board,Name,Team),
		clearscreen,
		play(Board,Team).
		
play(Board,Team) :- 			write('NEW TURN'),
								/*boardInfo,*/
								displayBoard(Board),
								moveShip(Board,Team,FinalBoard),
								/*clearscreen,*/
								play(FinalBoard,Team).


















