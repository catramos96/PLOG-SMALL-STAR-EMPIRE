/************************
*	FUNCTIONALITIES		*
************************/

:-include('GameRules.pl').
/*:-include('Board.pl').
:-include('Player.pl').	*/

loadPlayers(Board,P1,P2) :- 	getCell(Board,R1,C1,[6,0,N1]),
								createPlayer(1,N1,[R1|C1],P1),
								getCell(Board,R2,C2,[6,2,N2]),
								createPlayer(2,N2,[R2|C2],P2).								

moveShip_settings(Ri,Ci,Rf,Cf) :- 	nl, write('From Row'), read(Ri),
										write('From Column'),read(Ci),
										write('To Row'), read(Rf),
										write('To Column'),read(Cf), nl .
										
addControl(Board,Pi,Rf,Cf,Final,Pf) :- 	hasControl(Board,Rf,Cf,R2), R2 is 0, !,	
										write('Colony(C) or Trade(T)'),	read(Type),
										playerGetTeam(Pi,Team),
										setDominion(Board,Team,Rf,Cf,Type,Final),
										playerAddControl(Pi,Type,[Rf|Cf],Pf).
										
addControl(Board,Pi,_,_,Board,Pi) :- 	nl,write('No Control to add'), nl .	
									
moveShip(Board,Pi,FinalBoard,Pf,1) :- 	moveShip_settings(Ri,Ci,Rf,Cf),
										validMove(Board,Pi,Ri,Ci,Rf,Cf,1),!,									
										addControl(Board,Pi,Rf,Cf,Tmp1,Pt),
										setShip(Tmp1,Rf,Cf,1,Tmp2),
										setShip(Tmp2,Ri,Ci,-1,FinalBoard),
										playerSetShip(Pt,[Ri|Ci],[Rf|Cf],Pf).
				
moveShip(Board,P,Board,P,0) :- 	nl,write('Movimento invalido!'), nl .