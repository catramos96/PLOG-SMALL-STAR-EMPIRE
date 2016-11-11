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
									
play(Board,1,P1i,P2i,P1f,P2f,FinalBoard) :- 	/*clearscreen,*/
												turn(Board,P1i,BoardT,P1t), !,
												gameOver(BoardT,P1t,P2i,R),
												(	(R is 0 , play(BoardT,2,P1t,P2i,P1f,P2f,FinalBoard));
													(P1f is P1t, P2f is P2i,BoardT is FinalBoard)
												).
												
												/*clearscreen,
												turn(BoardT1,P2i,BoardT2,P2t), !,
												gameOver(Board,P1t,P2t),
												play(BoardT2,P1t,P2t,P1f,P2f,FinalBoard).*/
												
play(Board,2,P1i,P2i,P1f,P2f,FinalBoard) :- 	/*clearscreen,*/
												turn(Board,P2i,BoardT,P2t), !,
												gameOver(BoardT,P1i,P2t,R),
												(	(R is 0 , play(BoardT,2,P1i,P2t,P1f,P2f,FinalBoard));
													(P1f is P1i, P2f is P2t,BoardT is FinalBoard)
												).
								
game :- game_settings(Board,P1,P2),
		play(Board,1,P1,P2,P1f,P2f,Bf), !,
		write('OUT'),
		displayPlayerInfo(P1f), nl, !,
		displayPlayerInfo(P2f), nl, !,
		displayBoard(Bf), !,
		/*board(4,Board),*/
		winner(Bf,P1f,P2f).

	
winner(Board,P1,P2):- 	playerGetPoints(Board,P1,ListLength1,Points1), 
						playerGetPoints(Board,P2,ListLength2,Points2),
						biggestTerritoryPoints(ListLength1, Points1, NewPoints1, ListLength2, Points2, NewPoints2), 
						chooseWinner(P1, NewPoints1, P2, NewPoints2) .
					
playerGetPoints(Board,Player,ListLength,Points) :-  playerTerritory(Player,List), 
													length(List,ListLength),
													countPoints(Board,List,0,Points,0,0).
	
	
playerTerritory(Player, List) :- getListElem(Player,2,Trade), getListElem(Player,3,Colony), append(Colony, Trade, List) .	

/*se accR e ou accB: 1->+1; 2->+4; 3->+7; */
countPoints(_,[],Points,FinalPoints,AccB, AccR) :- 	getNebulaePoints(Points, AccB, NewPoints),
													getNebulaePoints(NewPoints, AccR, FinalPoints) .

/*deve percorrer todos as colonia/trades: se 1,2 ou 3 soma; se 4 ou 5 coloca num acumulador ; 
  verificar adjacentes as trades (+1 por cada inimigo adjacente)*/
countPoints(Board,[[R|[C|[]]]|Lb], AccPoints, FinalPoints, AccB, AccR) :-   getBoardCell(Board,R,C,[SystemID|[DominionID|_]]),
																			getTradePoints(Board,R,C,DominionID,1,AccPoints,AccPoints1),
																			getSystemTypePoints(SystemID,P,AccB,AccR,NewAccB,NewAccR), 
																			NewPoints is AccPoints1 + P , 
																			countPoints(Board,Lb,NewPoints,FinalPoints, NewAccB, NewAccR) .

getTradePointsAux(Board,R,C,Acc,Team,Points,NewPoints) :- 	Team == 1,
															getCellDirection(Board,R,C,Acc,Rf,Cf), 
															getBoardCell(Board,Rf,Cf,[_|[2|_]]), !,
															NewPoints is Points + 1 .
getTradePointsAux(Board,R,C,Acc,Team,Points,NewPoints) :- 	Team == 2,
															getCellDirection(Board,R,C,Acc,Rf,Cf), 
															getBoardCell(Board,Rf,Cf,[_|[1|_]]), !,
															NewPoints is Points + 1 .															
getTradePointsAux(_,_,_,_,_,Points,Points).
																			
getTradePoints(Board,R,C,DominionID,Acc,Points,FinalPoints) :- 	dominion(DominionID,Team,'T'), Acc > 0, Acc < 7, 
																getTradePointsAux(Board,R,C,Acc,Team,Points,NewPoints),
																NewAcc is Acc + 1, 
																getTradePoints(Board,R,C,DominionID,NewAcc,NewPoints,FinalPoints) .

getTradePoints(_,_,_,_,_,Points,Points) .
																			
getSystemTypePoints(ID,P, AccB,AccR, AccB,AccR) :- (ID == 1 ; ID == 2; ID == 3), systemType(ID,_,P).
getSystemTypePoints(4,0,AccB,AccR,AccB,NewAccR) :- (NewAccR is AccR + 1) .
getSystemTypePoints(5,0,AccB,AccR,NewAccB,AccR) :- (NewAccB is AccB + 1) .
getSystemTypePoints(_,0,AccB,AccR,AccB,AccR) .

getNebulaePoints(Points, 0, Points).
getNebulaePoints(Points, 1, NewPoints) :- NewPoints is Points + 1 .
getNebulaePoints(Points, 2, NewPoints) :- NewPoints is Points + 4 .
getNebulaePoints(Points, 3, NewPoints) :- NewPoints is Points + 7 .
	
biggestTerritoryPoints(Length1, Points1, NewPoints1, Length2, Points2, Points2) :- Length1 > Length2, NewPoints1 is Points1 + 3.
biggestTerritoryPoints(Length1, Points1, Points1, Length2, Points2, NewPoints2) :- Length1 < Length2 , NewPoints2 is Points2 + 3 .
biggestTerritoryPoints(Length1, Points1, Points1, Length2, Points2, Points2) :- Length1 == Length2 .															
																					
chooseWinner(_, Points, _, Points)	:-	nl,write('DRAW!').	
chooseWinner(P1, Points1,_, Points2) :-   Points1 > Points2, displayWinner(P1, Points1).
chooseWinner(_, Points1, P2, Points2) :-   	Points1 < Points2, displayWinner(P2, Points2).

displayWinner(Player, Points) :-	nl, write('THE WINNER IS - '), displayTeamName(Player), 
									write(' WITH '), write(Points), write(' POINTS!'),nl .