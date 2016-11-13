/************************
*		SCORES			*
************************/

/* 
Decides wich player wins the game, counting the points of wich player. 
*/
winner(Board,P1,P2):- 	playerGetPoints(Board,P1,ListLength1,Points1),	
						playerGetPoints(Board,P2,ListLength2,Points2),
						biggestTerritoryPoints(ListLength1, Points1, NewPoints1, ListLength2, Points2, NewPoints2), 	%more 3 points for the player with the biggest territory
						chooseWinner(Board,P1,NewPoints1,P2,NewPoints2) .	%compares the points
					
playerGetPoints(Board,Player,ListLength,Points) :-  playerTerritory(Player,List), %build player's territory (colonies + trades)
													length(List,ListLength),
													countPoints(Board,List,0,Points,0,0).	%counts the points

/*
Tranverses the territory (colonies and trades) and verifies the System Type.
If the System Type is 'Star', receives the points of that star;
If the Territory is trade, verifies all the adjacent cells. Receives the points of the number of enemies in the adjacent cells;
If the System Type is Nebulae, increments the accB (for blue nebulae) or accR (for red nebulae);
At the end, receives the points for Nebulaes depending on accB and accR.
*/
countPoints(_,[],Points,FinalPoints,AccB, AccR) :- 	getNebulaePoints(Points, AccB, NewPoints),
													getNebulaePoints(NewPoints, AccR, FinalPoints) .
countPoints(Board,[[R|[C|[]]]|Lb], AccPoints, FinalPoints, AccB, AccR) :-   getBoardCell(Board,R,C,[SystemID|[DominionID|_]]),	
																			getTradePoints(Board,R,C,DominionID,AccPoints,TempPoints),
																			getSystemTypePoints(SystemID,P,AccB,AccR,NewAccB,NewAccR), 
																			NewPoints is TempPoints + P , 
																			countPoints(Board,Lb,NewPoints,FinalPoints, NewAccB, NewAccR) .														

/*
Auxiliar method. Receives the list of adjacent cells and increments 1 point for each enemy.
If the team is no. 1, the enemy is no. 2, and vice-versa.
*/																			
getTradePointsAux(_,[],_,Points,Points) .
getTradePointsAux(Board,[[R|C]|Cr],1,Acc,Points) :-	getBoardCell(Board,R,C,[_|[DominionID|_]]), dominion(DominionID,2,_),!,		%verifies if the cell corresponds to the enemy
													NewAcc is Acc + 1 ,
													getTradePointsAux(Board,Cr,1,NewAcc,Points) .													
getTradePointsAux(Board,[[R|C]|Cr],2,Acc,Points) :-	getBoardCell(Board,R,C,[_|[DominionID|_]]), dominion(DominionID,1,_),!,
													NewAcc is Acc + 1 ,
													getTradePointsAux(Board,Cr,2,NewAcc,Points) .												
getTradePointsAux(Board,[_|Cr],Team,Acc,Points) :-	getTradePointsAux(Board,Cr,Team,Acc,Points) .

/*
Verifies if my ship has type 'Trade' and calculates the adjacent cells. Then use my auxiliar method to receive the points.
*/																					
getTradePoints(Board,R,C,DominionID,Points,FinalPoints) :- 	dominion(DominionID,Team,'T'),  		%My dominion is Trade
															getAdjCells(Board,R,C,AdjCells),		
															getTradePointsAux(Board,AdjCells,Team,0,NewPoints),	/* calculo dos pontos dessa trade */
															FinalPoints is Points + NewPoints .
getTradePoints(_,_,_,_,Points,Points) .

/*
If type star, receives the the points; If type Nebulae, increments de acc.
*/																			
getSystemTypePoints(ID,P, AccB,AccR, AccB,AccR) :- (ID == 1 ; ID == 2; ID == 3), systemType(ID,_,P).
getSystemTypePoints(4,0,AccB,AccR,AccB,NewAccR) :- (NewAccR is AccR + 1) .
getSystemTypePoints(5,0,AccB,AccR,NewAccB,AccR) :- (NewAccB is AccB + 1) .
getSystemTypePoints(_,0,AccB,AccR,AccB,AccR) .

/*
Receives the points depending on the number of Nebulae of wich color.
*/
getNebulaePoints(Points, 0, Points).
getNebulaePoints(Points, 1, NewPoints) :- NewPoints is Points + 1 .
getNebulaePoints(Points, 2, NewPoints) :- NewPoints is Points + 4 .
getNebulaePoints(Points, 3, NewPoints) :- NewPoints is Points + 7 .

/*
3 more points for the player with the biggest territory
*/	
biggestTerritoryPoints(Length1, Points1, NewPoints1, Length2, Points2, Points2) :- Length1 > Length2, NewPoints1 is Points1 + 3.
biggestTerritoryPoints(Length1, Points1, Points1, Length2, Points2, NewPoints2) :- Length1 < Length2 , NewPoints2 is Points2 + 3 .
biggestTerritoryPoints(Length1, Points1, Points1, Length2, Points2, Points2) :- Length1 == Length2 .															

/*
Displays the winner with most points.
*/																					
chooseWinner(Board,_,Points,_,Points)	:-	displayBoard(Board),nl,write('DRAW!').	
chooseWinner(Board,P1,Points1,_,Points2) :- Points1 > Points2, displayWinner(Board,P1,Points1,Points2).
chooseWinner(Board,_,Points1,P2,Points2) :- Points1 < Points2, displayWinner(Board,P2,Points1,Points2).
