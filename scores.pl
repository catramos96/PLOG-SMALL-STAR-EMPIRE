/************************
*		SCORES			*
************************/

winner(Board,P1,P2):- 	playerGetPoints(Board,P1,ListLength1,Points1), nl,
						playerGetPoints(Board,P2,ListLength2,Points2),
						biggestTerritoryPoints(ListLength1, Points1, NewPoints1, ListLength2, Points2, NewPoints2), 
						chooseWinner(Board,P1,NewPoints1,P2,NewPoints2) .
					
playerGetPoints(Board,Player,ListLength,Points) :-  playerTerritory(Player,List), 
													length(List,ListLength),
													countPoints(Board,List,0,Points,0,0).

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

getTradePointsAux(_,[],_,Points,Points).
getTradePointsAux(Board,[[R|[C|[]]]|Cr],1,Acc,Points) :-	getBoardCell(Board,R,C,[_|[2|_]]), !,
															NewAcc is Acc + 1 ,
															getTradePointsAux(Board,Cr,1,NewAcc,Points) .
getTradePointsAux(Board,[[R|[C|[]]]|Cr],2,Acc,Points) :-	getBoardCell(Board,R,C,[_|[1|_]]), !,
															NewAcc is Acc + 1 ,
															getTradePointsAux(Board,Cr,2,NewAcc,Points) .
getTradePointsAux(Board,[_|Cr],Team,Acc,Points) :-	getTradePointsAux(Board,Cr,Team,Acc,Points) .			
																			
getTradePoints(Board,R,C,DominionID,Points,FinalPoints) :- 	dominion(DominionID,Team,'T'),  		/* o meu dominio e uma trade */
															getAdjCells(Board,R,C,AdjCells),		/* verifico quais sao as celulas a volta */
															getTradePointsAux(Board,AdjCells,Team,0,NewPoints),	/* calculo dos pontos dessa trade */
															FinalPoints is Points + NewPoints .
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
																					
chooseWinner(Board,_,Points,_,Points)	:-	displayBoard(Board),nl,write('DRAW!').	
chooseWinner(Board,P1,Points1,_,Points2) :-   Points1 > Points2, displayWinner(Board,P1,Points1).
chooseWinner(Board,_,Points1,P2,Points2) :-   	Points1 < Points2, displayWinner(Board,P2,Points2).

displayWinner(Board, Player, Points) :- displayBoard(Board),
										nl, write('THE WINNER IS - '), displayTeamName(Player), 
										write(' WITH '), write(Points), write(' POINTS!'), nl .