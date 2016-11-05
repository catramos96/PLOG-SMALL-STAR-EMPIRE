/********************************************
************ SMALL STAR EMPIRE **************
*********************************************/

load :- use_module(library(lists)).
	
/************************
*		MATRIX			*
************************/
matrix([[1,2,3],
		[4,5,6],
		[7,8,9]]).
%GETS
getCell(Mat,Row,Column,Value) :- nth1(Row, Mat, ARow), nth1(Column, ARow, Value).	

%SETS
setCellValue(M,R,C,V,F) :-	setCell(M,R,C,1,1,V,[],F).

setCell([],_,_,_,_,_,F,F).
setCell([L1|L2],R,C,Nr,Nc,V,T,Mf) :- 	R is Nr, ! , setCellRow(L1,C,Nc,V,[],Rf),
										append(T,[Rf|[]],T2),
										Nr1 = Nr + 1,
										setCell(L2,R,C,Nr1,Nc,V,T2,Mf).	
										
setCell([L1|L2],R,C,Nr,Nc,V,T,Mf) :- 	append(T,[L1|[]],T2),
										Nr1 = Nr + 1,
										setCell(L2,R,C,Nr1,Nc,V,T2,Mf).
										
setCellRow([],_,_,_,F,F).
setCellRow([_|L2],C,Nc,V,T,F) :- 	C is Nc ,!, append(T,[V|[]],T2),
									Nc1 = Nc + 1,
									setCellRow(L2,C,Nc1,V,T2,F).
									
setCellRow([L1|L2],C,Nc,V,T,F) :- 	append(T,[L1|[]],T2),
									Nc1 = Nc + 1,
									setCellRow(L2,C,Nc1,V,T2,F).		

%DISPLAYS									
displayM([L1|L2]) :- 	displayList(L1),nl, displayM(L2).				
displayM([]).
	
/************************
*		 LIST			*
************************/

list([1,2,3,4,5]).		%TO_TEST

%ADD
addList(E,L1,L2) :- 	append(L1,[E|[]],L2).

%REMOVE
remList(E,L1,L2) :-		append(_Y,[E|_Z],L1),append(_Y,_Z,L2).

%SET
setList(E,L1,C,L2) :- 	setCellRow(L1,C,1,E,[],L2).	

%GET
getListElem(L1,P,E) :- 	nth1(P,L1,E).

%DISPLAY
displayList([L1|L2]) :- write(L1),write(' '),displayList(L2).
displayList([]).


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

%DISPLAY
displayDominion(I) :- dominion(I,P,C), write(P), write(C).
displaySystem(I) :- systemType(I,A,B),write(A),write(B).
displayCell([IDs|[IDp|[N|[]]]]) :- systemType(IDs,_,_), dominion(IDp,_,_), displaySystem(IDs),write(','),displayDominion(IDp),write(','),write(N).

/************************
*		BOARD			*
************************/

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

%DISPLAYS	 
displayBoard([L1|L2]) :- nl, displayTopLine(L1), displayMatrix2D([L1|L2]).

displayMatrix2D([]) :- nl .
displayMatrix2D([L1|L2]) :- displayLine(L1),nl, displayMatrix2D(L2).

displayLine([L1|L2]) :- displayLine1([L1|L2]), displayLine2([L1|L2]), displayBottomLine([L1|L2]).	%LINE

displayTopLine([]):- nl.
displayTopLine([E1|E2]) :- ((E1 == 0 , write('  ')); write(' / \\')),displayTopLine(E2).			%TOP_LINE_LIMIT

displayLine1([]):- write('|'),nl.	
displayLine1([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo1(E1)),displayLine1(E2).				%TOP_LINE_INFO
	
displayLine2([]):- write('|'),nl.
displayLine2([E1|E2]) :- ((E1 == 0 , write('  '));displayInfo2(E1)),displayLine2(E2).				%BOTTOM_LINE_INFO

displayBottomLine([]):- write(' \\').
displayBottomLine([E1|E2]) :- ((E1 == 0 , write(' /'));write(' \\ /')),displayBottomLine(E2).		%BOTTOM_LINE_LIMIT

displayInfo1([IDs|_]) :- systemType(IDs,_,_), write('|'), displaySystem(IDs), write(' ').
displayInfo2([IDs|[IDp|[N|[]]]]) :- systemType(IDs,_,_), dominion(IDp,_,_), write('|'),displayDominion(IDp),(N == 0, write(' ');write(N)).

%GETS
getBoardCell(B,R,C,V) :- getCell(B,R,1,X), X == 0 ,!,C1 is C + 1, getCell(B,R,C1,V).
getBoardCell(B,R,C,V) :- getCell(B,R,C,V).

%SETS
setBoardCell(B,R,C,V,F) :- getCell(B,R,1,X), X == 0 ,!, C1 is C+1,setCellValue(B,R,C1,V,F).
setBoardCell(B,R,C,V,F) :- setCellValue(B,R,C,V,F).

/************************
*		PLAYER			*
************************/
								
player1 :- 	[1,[],[],[]].		
player2 :-	[2,[],[],[]].	

%CREATE
createPlayer(Team,NShips,Base,P) :-		playerAddBaseShips([Team,[],[],[]],NShips,Base,P).
										
playerAddBaseShips(Pi,NShips,Base,Pf) :- 	NShips \= 0,
											playerAddShip(Pi,Base,T), N1 is NShips-1,
											playerAddBaseShips(T,N1,Base,Pf).

playerAddBaseShips(Pi,_,_,Pi).
	
%GETS	
playerGetTeam([T|_],T).
playerGetShips(Pi,S) :- getListElem(Pi,4,S).

%SETS
playerSetShip(Pi,SPosi,SPosf,Pf) :-	playerRemShip(Pi,SPosi,Pt) , playerAddShip(Pt,SPosf,Pf).

%ADDS
playerAddControl(Pi,Type,Tpos,Pf) :-	Type == 'C', !,							
										playerAddColony(Pi,Tpos,Pf).										
playerAddControl(Pi,Type,Tpos,Pf) :-	Type == 'T', !,
										playerAddTrade(Pi,Tpos,Pf).
playerAddControl(Pi,_,_,Pi).																
										
playerAddTrade(Pi,TPos,Pf) :- 	getListElem(Pi,2,Tr), addList(TPos,Tr,Trf), setList(Trf,Pi,2,Pf).	
playerAddColony(Pi,CPos,Pf) :- 	getListElem(Pi,3,C), addList(CPos,C,Cf), setList(Cf,Pi,3,Pf).
playerAddShip(Pi,SPos,Pf) :- 	getListElem(Pi,4,S), addList(SPos,S,Sf), setList(Sf,Pi,4,Pf).

%REMOVE
playerRemShip(Pi,SPos,Pf) :-	getListElem(Pi,4,S), remList(SPos,S,Sf), setList(Sf,Pi,4,Pf).	

%DISPLAYS
displayTeamName(P) :- 	playerGetTeam(P,T), T is 1, !,
						write('Blue Team'),nl.

displayTeamName(P) :-	playerGetTeam(P,T), T is 2, !,
						write('Red Team'),nl.

displayPlayerInfo([_|[Tr|[C|[S|[]]]]]) :- 	write('TRADES: '),nl, displayList(Tr), nl, nl,
											write('COLONIES: '), nl ,displayList(C), nl, nl,
											write('SHIPS: '), nl, displayList(S),nl, nl.


/************************
*	GAME GETS & SETS	*
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


/************************
*	FUNCTIONALITIES		*
************************/

loadPlayers(Board,P1,P2) :- 	getCell(Board,R1,C1,[6,0,N1]),
								createPlayer(1,N1,[R1|C1],P1),
								getCell(Board,R2,C2,[6,2,N2]),
								createPlayer(2,N2,[R2|C2],P2).								

moveShip_settings(Ri,Ci,Rf,Cf) :- 	nl, write('From Row'), read(Ri),
										write('From Column'),read(Ci),
										write('To Row'), read(Rf),
										write('To Column'),read(Cf), nl.
										
addControl(Board,Pi,Rf,Cf,Final,Pf) :- 	hasControl(Board,Rf,Cf,R2), R2 is 0, !,	
										write('Colony(C) or Trade(T)'),	read(Type),
										playerGetTeam(Pi,Team),
										placeControl(Board,Team,Rf,Cf,Type,Final),
										playerAddControl(Pi,Type,[Rf|Cf],Pf).
										
addControl(Board,Pi,_,_,Board,Pi) :- 	nl,write('No Control to add'), nl.	
									
moveShip(Board,Pi,FinalBoard,Pf,1) :- 	moveShip_settings(Ri,Ci,Rf,Cf),
										validMove(Board,Pi,Ri,Ci,Rf,Cf,1),!,									
										addControl(Board,Pi,Rf,Cf,Tmp1,Pt),
										placeShip(Tmp1,Rf,Cf,1,Tmp2),
										placeShip(Tmp2,Ri,Ci,-1,FinalBoard),
										playerSetShip(Pt,[Ri|Ci],[Rf|Cf],Pf).
				
moveShip(Board,P,Board,P,0) :- 	nl,write('Movimento invalido!'), nl.
														
/************************
*	      GAME			*
************************/

clearscreen :- write('\e[2J').

game_settings(Board,P1,P2) :- 	load, clearscreen,
								board_settings(Board),
								loadPlayers(Board,P1,P2).
	
make_move(Board,Pi,FinalBoard,Pf) :-	moveShip(Board,Pi,FinalBoard,Pf,1).

make_move(Board,Pi,FinalBoard,Pf) :- 	moveShip(Board,Pi,_,_,0), !,
										make_move(Board,Pi,FinalBoard,Pf).
									
turn(Board,Pi,FinalBoard,Pf) :- 	nl,write('NEW TURN - '), 
									displayTeamName(Pi),
									displayBoard(Board),
									displayPlayerInfo(Pi),
									make_move(Board,Pi,FinalBoard,Pf).
								
play(Board,P1i,P2i,P1f,P2f) :- 	clearscreen,
								turn(Board,P1i,BoardT,P1t),
								clearscreen,
								turn(BoardT,P2i,FinalBoard,P2t),
								play(FinalBoard,P1t,P2t,P1f,P2f).
				
game :- clearscreen,
		game_settings(Board,P1,P2),
		play(Board,P1,P2,P1f,P2f).


















