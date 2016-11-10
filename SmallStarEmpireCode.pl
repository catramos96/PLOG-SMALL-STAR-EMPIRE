/********************************************
************ SMALL STAR EMPIRE **************
*********************************************/

:-include('Board.pl').
:-include('Player.pl').	
:-include('GameFunctionalities.pl')	.					
														
/************************
*	      GAME			*
************************/

clearscreen :- write('\e[2J').

game_settings(Board,P1,P2) :- 	clearscreen,
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
								%play(FinalBoard,P1t,P2t,P1f,P2f).
								displayBoard(FinalBoard), %faz ultimo display
								winner(FinalBoard,P1t,P2t) .
				
game :- game_settings(Board,P1,P2),
		play(Board,P1,P2,P1f,P2f).

	
winner(Board,P1,P2):- 	playerGetPoints(Board,P1,ShipsLength1,Points1),
						playerGetPoints(Board,P2,ShipsLength2,Points2),
						biggestTerritoryPoints(ShipsLength1, Points1, NewPoints1, ShipsLength2, PointsFinal2, NewPoints2), %verifica quem tem mais colonias e da mais 3 pontos a esse
						chooseWinner(P1, NewPoints1, P2, NewPoints2) .	

playerGetPoints(Board,Player,ShipsLength,Points) :- playerTerritory(Player,TotalShips), length(TotalShips, ShipsLength), write('>>>>'),write(ShipsLength),
													countPoints(Board,TotalShips,0,0,0,Points). 	
	
playerTerritory(Player, List) :- getListElem(Player,2,Trade), getListElem(Player,3,Colony), append(Colony, Trade, List) .	
	
%depois de percorrer a matriz:
%	se accR e/ou accB: 1->+1; 2->+4; 3->+7;
%	verificar adjacentes as trades (+1 por cada inimigo adjacente)
countPoints(Player, [], Points, AccR, AccB, PointsFinal).

%deve percorrer todos os ships:
%	se 1,2 ou 3 soma
%	se 4 ou 5 coloca num acumulador
countPoints(Board,[[R|C]|Lb],Points,AccR,AccB,PointsFinal) :- 	getBoardCell(Board,R,C,SystemType),
																getSystemTypePoints(SystemType,P,AccB,AccR,NewAccB,NewAccR), %analisa o Value
																PointsFinal = Points + P,
																countPoints(Board,Lb,Points,NewAccB,NewAccR,PointsFinal) .		
																
getSystemTypePoints(SystemType,P,_,_,_,_) :- (SystemType == 1 ; SystemType == 2; SystemType == 3), systemType(SystemType,_,P).	
														
getSystemTypePoints(SystemType,_,AccB,AccR,NewAccB,NewAccR) :- 	(SystemType == 4, NewAccB = AccB + 1, NewAccR = AccR) ;
																(SystemType == 5, NewAccR = AccR + 1, NewAccB = AccB) .
																
biggestTerritoryPoints(Ships1, Points1, NewPoints1, Ships2, Points2, NewPoints2) :- Ships1 > Ships2, 
																					NewPoints1 = Points1 + 3, NewPoints2 = Points2.
biggestTerritoryPoints(Ships1, Points1, NewPoints1, Ships2, Points2, NewPoints2) :- Ships1 < Ships2, 
																					NewPoints1 = Points1, NewPoints2 = Points2 + 3 .
biggestTerritoryPoints(Ships1, Points1, NewPoints1, Ships2, Points2, NewPoints2) :- Ships1 == Ships2, 
																					NewPoints1 = Points1, NewPoints2 = Points2 .
																					
chooseWinner(_, Points, _, Points)	:-	nl,write('DRAW!').	
chooseWinner(P1, Points1, P2, Points2) :-   Points1 > Points2, displayWinner(P1, Points1).
chooseWinner(P1, Points1, P2, Points2) :-   Points1 < Points2, displayWinner(P2, Points2).

displayWinner(Player, Points) :-	nl, write('THE WINNER IS - '), displayTeamName(Player), 
									write(' WITH '), write(Points), write(' POINTS!'),nl .