/************************
*	FUNCTIONALITIES		*
************************/

:-include('GameRules.pl').


loadPlayers(Board,P1,P2) :- 	getCell(Board,R1,C1,[6,0,N1]),								
								createPlayer(1,N1,[R1|[C1|[]]],P1),
								getCell(Board,R2,C2,[6,2,N2]),
								createPlayer(2,N2,[R2|[C2|[]]],P2).						

								
								
turn(Mode,Board,Pi,FinalBoard,Pf) :- 	updateValidShips(Board,Pi,Pt1), !,
										getPossibleMoves(Board,Pt1,M), !,
										M \= [],									/*Game Over if M = []*/
										displayTurn(Board,Pt1,M), 
										make_move(Mode,Board,M,Pt1,FinalBoard,Pf).
		
		
		
make_move(Mode,Board,M,Pi,FinalBoard,Pf) :-		movement(Mode,Ri,Ci,Rf,Cf), !,								%SUCCESS
												validMove(M,Pi,Ri,Ci,Rf,Cf), !,							
												addControl(Board,Pi,Rf,Cf,Tmp1,Pt), !,
												setShip(Tmp1,Rf,Cf,1,Tmp2), !,
												setShip(Tmp2,Ri,Ci,-1,FinalBoard), !,
												playerSetShip(Pt,[Ri|[Ci|[]]],[Rf|[Cf|[]]],Pf).	
												
make_move(Mode,Board,M,Pi,FinalBoard,Pf) :- 	make_move(Mode, Board,M,Pi,FinalBoard,Pf).	%FAIL
							
							
										
addControl(Board,Pi,Rf,Cf,Final,Pf) :-  addDominion_settings(Type), !,									%SUCCESS
										playerGetTeam(Pi,Team),								
										setDominion(Board,Team,Rf,Cf,Type,Final), !,
										playerAddControl(Pi,Type,[Rf|[Cf|[]]],Pf).		
										
addControl(Board,Pi,Rf,Cf,Final,Pf) :- 	error(2), addControl(Board,Pi,Rf,Cf,Final,Pf).					%FAIL
			
			
			
movement(0,Ri,Ci,Rf,Cf) :- moveShip_settings(Ri,Ci,Rf,Cf).				%PERSON
movement(0,Ri,Ci,Rf,Cf) :- error(4), moveShip_settings(Ri,Ci,Rf,Cf).

movement(1,_,_,_,_).								%COMPUTER