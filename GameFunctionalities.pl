/************************
*	FUNCTIONALITIES		*
************************/

:-include('GameRules.pl').
:-include('Board.pl').
/*:-include('Player.pl').	*/

clearscreen :- write('\e[2J').

game_settings(Board,P1,P2) :- 	clearscreen,
								board_settings(Board),
								loadPlayers(Board,P1,P2).
								
loadPlayers(Board,P1,P2) :- 	getCell(Board,R1,C1,[6,0,N1]),
								createPlayer(1,N1,[R1|C1],P1),
								getCell(Board,R2,C2,[6,2,N2]),
								createPlayer(2,N2,[R2|C2],P2).
								
								
play(Board,P1i,P2i,P1f,P2f) :- 	clearscreen,
								turn(Board,P1i,BoardT,P1t),
								clearscreen,
								turn(BoardT,P2i,FinalBoard,P2t),
								play(FinalBoard,P1t,P2t,P1f,P2f).
								
									
turn(Board,Pi,FinalBoard,Pf) :- 	nl,write('NEW TURN - '), 
									displayTeamName(Pi),
									displayBoard(Board),
									displayPlayerInfo(Pi),
									make_move(Board,Pi,FinalBoard,Pf).
									
make_move(Board,Pi,FinalBoard,Pf) :-	moveShip(Board,Pi,FinalBoard,Pf,1).

make_move(Board,Pi,FinalBoard,Pf) :- 	moveShip(Board,Pi,_,_,0), !,
										make_move(Board,Pi,FinalBoard,Pf).
										
moveShip(Board,Pi,FinalBoard,Pf,1) :- 	moveShip_settings(Ri,Ci,Rf,Cf),
										validMove(Board,Pi,Ri,Ci,Rf,Cf,1),!,									
										addControl(Board,Pi,Rf,Cf,Tmp1,Pt),
										placeShip(Tmp1,Rf,Cf,1,Tmp2),
										placeShip(Tmp2,Ri,Ci,-1,FinalBoard),
										playerSetShip(Pt,[Ri|Ci],[Rf|Cf],Pf).
				
moveShip(Board,P,Board,P,0) :- 	nl,write('Movimento invalido!'), nl.
									
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
									
