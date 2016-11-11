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
								
make_move(Mode, Board,Pi,FinalBoard,Pf) :-	moveShip(Mode, Board,Pi,FinalBoard,Pf,1).

make_move(Mode, Board,Pi,FinalBoard,Pf) :- 	moveShip(Mode, Board,Pi,_,_,0), !,
											make_move(Mode, Board,Pi,FinalBoard,Pf).
								
turn(Mode,Board,Pi,FinalBoard,Pf) :- 	nl,write('NEW TURN - '),
										displayTeamName(Pi),
										displayBoard(Board),
										updateValidShips(Board,Pi,Pt1),
										displayPlayerInfo(Pt1),
										make_move(Mode,Board,Pt1,FinalBoard,Pf).
									
play(Board,1,P1i,P2i,P1f,P2f,FinalBoard) :- 	/*clearscreen,*/
												turn(0,Board,P1i,BoardT,P1t), !,					/*TEMPORARIO : acrescentado o modo de jogo(humano ou maquina) */
												gameOver(P1t,P2i,R),
												(	(R is 0 , play(BoardT,2,P1t,P2i,P1f,P2f,FinalBoard));
													(R is 1, append(P1t,[],P1f), append(P2i,[],P2f),append(BoardT,[],FinalBoard))
												).
												
play(Board,2,P1i,P2i,P1f,P2f,FinalBoard) :- 	/*clearscreen,*/
												turn(0,Board,P2i,BoardT,P2t), !,
												gameOver(P1i,P2t,R),
												(	(R is 0 , play(BoardT,1,P1i,P2t,P1f,P2f,FinalBoard));
													(R is 1, append(P1i,[],P1f), append(P2t,[],P2f),append(BoardT,[],FinalBoard))
												).
								
game :- game_settings(Board,P1,P2),
		play(Board,1,P1,P2,P1f,P2f,Bf), !,
		write('OUT'),
		displayPlayerInfo(P1f), nl, !,
		displayPlayerInfo(P2f), nl, !,
		displayBoard(Bf), !,
		/*board(4,Board),*/
		winner(Bf,P1f,P2f).
		
/* ================================================================================ */
	
winner(Board,P1,P2):- 	playerGetPoints(Board,P1,ListLength1,Points1), 
						playerGetPoints(Board,P2,ListLength2,Points2),
						biggestTerritoryPoints(ListLength1, Points1, NewPoints1, ListLength2, Points2, NewPoints2), 
						chooseWinner(P1, NewPoints1, P2, NewPoints2) .
					
playerGetPoints(Board,Player,ListLength,Points) :-  playerTerritory(Player,List), 
													length(List,ListLength),
													countPoints(Board,List,0,Points,0,0).
	
	
playerTerritory(Player, List) :- getListElem(Player,2,Trade), getListElem(Player,3,Colony), append(Colony, Trade, List) .	

/*se accR e ou accB: 1->+1; 2->+4; 3->+7; verificar adjacentes as trades (+1 por cada inimigo adjacente)*/
countPoints(_,[],Points,FinalPoints,AccB, AccR) :- 	getNebulaePoints(Points, AccB, NewPoints),
													getNebulaePoints(NewPoints, AccR, FinalPoints) .

/*deve percorrer todos as colonia/trades: se 1,2 ou 3 soma; se 4 ou 5 coloca num acumulador*/
countPoints(Board,[[R|[C|[]]]|Lb], AccPoints, FinalPoints, AccB, AccR) :-   getBoardCell(Board,R,C,[ID|_]), 
																			getSystemTypePoints(ID,P,AccB,AccR,NewAccB,NewAccR), 
																			/*getTradePoints(Board,R,C,Team,1,AccPoints),*/
																			NewPoints is AccPoints + P , 
																			countPoints(Board,Lb,NewPoints,FinalPoints, NewAccB, NewAccR) .
																			
getTradePoints(Board,R,C,Team,Acc,Points) :- Team == 1, Acc > 0, Acc < 7, 
											getCellInDirection(Board,R,C,Acc,_,_,[_|[2|_]]), 
											NewPoints is Points + 1,
											NewAcc is Acc + 1,
											getTradePoints(Board,R,C,Team,NewAcc,NewPoints) .
											
getTradePoints(Board,R,C,Team,Acc,Points) :- Team == 2, Acc > 0, Acc < 7, 
											getCellInDirection(Board,R,C,Acc,_,_,[_|[1|_]]), 
											NewPoints is Points + 1,
											NewAcc is Acc + 1,
											getTradePoints(Board,R,C,Team,NewAcc,NewPoints) .
getTradePoints(_,_,_,_,_,Points) .
																			
getSystemTypePoints(ID,P, AccB,AccR, AccB,AccR) :- (ID == 1 ; ID == 2; ID == 3), systemType(ID,_,P).
getSystemTypePoints(4,0,AccB,AccR,AccB,NewAccR) :- (NewAccR is AccR + 1) .
getSystemTypePoints(5,0,AccB,AccR,NewAccB,AccR) :- (NewAccB is AccB + 1) .
getSystemTypePoints(ID,0,AccB,AccR,AccB,AccR) .

getNebulaePoints(Points, 0, Points).
getNebulaePoints(Points, 1, NewPoints) :- NewPoints is Points + 1 .
getNebulaePoints(Points, 2, NewPoints) :- NewPoints is Points + 4 .
getNebulaePoints(Points, 3, NewPoints) :- NewPoints is Points + 7 .
	
biggestTerritoryPoints(Length1, Points1, NewPoints1, Length2, Points2, Points2) :- Length1 > Length2, NewPoints1 is Points1 + 3.
biggestTerritoryPoints(Length1, Points1, Points1, Length2, Points2, NewPoints2) :- Length1 < Length2 , NewPoints2 is Points2 + 3 .
biggestTerritoryPoints(Length1, Points1, Points1, Length2, Points2, Points2) :- Length1 == Length2 .															
																					
chooseWinner(_, Points, _, Points)	:-	nl,write('DRAW!').	
chooseWinner(P1, Points1,_, Points2) :-   Points1 > Points2, displayWinner(P1, Points1).
chooseWinner(_, Points1, P2, Points2) :-   Points1 < Points2, displayWinner(P2, Points2).

displayWinner(Player, Points) :-	nl, write('THE WINNER IS - '), displayTeamName(Player), 
									write(' WITH '), write(Points), write(' POINTS!'),nl .