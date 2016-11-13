/*************************
*		INTERFACE		 *
*************************/

clearscreen :- write('\e[2J').

/*
header
displays a title with a border
*/
header(Title) :-	write('*****************************'),nl,
					write(Title), nl,
					write('*****************************'),nl,nl.

/*
menu
Inicial menu and options
*/					
menu(Choice) :-	clearscreen,
				header('SMALL STAR EMPIIRE'),
				write(' (1) PLAY'),nl,nl,
				write(' (2) EXIT'),nl,nl,
				read(Choice).

/*
game_settings
Game settings to play
*/
game_settings(Board,Nivel,Mode) :- 	clearscreen,
										header('GAME OPTIONS'),
										write('BOARD SETTINGS'), nl,
											write(' (1) SMALL'), nl,
											write(' (2) MEDIUM'), nl,
											write(' (3) BIG'),nl,
											read(BoardId), nl, nl,
										board(BoardId,Board),
										write('GAME MODE'), nl,
											write(' (1) Human vs Human'), nl,
											write(' (2) Human vs Computer'),nl,
											write(' (3) Computer vs Computer'),nl,
											read(Mode), nl,nl,
										(	((Mode is 2 ; Mode is 3), 
												write('NIVEL'),nl,
												write('(1) EASY'),nl,
												write('(2) HARD'),nl,
												read(Nivel), nl,nl) ;
											(Mode is 1, Nivel is 0)	
										).							 
																		
game_settings(Board,Nivel,Mode) :- error(5) , game_settings(Board,Nivel,Mode).
	
/*
displayTurn
Displays the information about the player and the board
*/
displayTurn(Board,Player,Moves) :-	clearscreen,
									playerTeamName(Player,TName),
									header(TName),
									displayBoardInfo,
									displayBoard(Board),
									displayPlayerInfo(Player),
									displayPossibleMoves(Player,Moves).
	
/*
moveShip_settings
Move ship options
*/								
moveShip_settings(RowI,ColumnI,RowF,ColumnF) :- 	write('CHOOSE SHIP'), nl,
													write(' From Row'), read(RowI),
													write(' From Column'),read(ColumnI),
													write('CHOOSE DESTINATION'),nl,
													write(' To Row'), read(RowF),
													write(' To Column'),read(ColumnF), nl,
													number(RowI),number(ColumnI),number(RowF),number(ColumnF).

/*
addDominion_settings
Add Dominion options
*/									
addDominion_settings(Type) :- 	write('CHOOSE DOMINION'),nl,
								write(' (\'C\') Colony'),nl,
								write(' (\'T\') Trade'),nl,
								read(Type), nl,
								(Type == 'C' ; Type == 'T').
	

/*
displayPossibleMoves
Displays the possibles moves for each Ship
*/									
displayPossibleMoves(Player,Moves) :- 	playerGetShips(Player,S) , write('POSSIBLE MOVES:'),nl,
										displayMovesAux(S,Moves),nl, nl.
displayMovesAux([],_).
displayMovesAux(_,[]).
displayMovesAux([S|Sn],[Moves|Mn]) :- 	write(' SHIP - '), write(S), write('    '),
										displayList(Moves),nl, !,
										displayMovesAux(Sn,Mn).
								
/*
displayWinner
Displays the winner and the points of the two players
*/									
displayWinner(Board,Player,Points1,Points2) :-	clearscreen,
												header('GAME OVER'),
												displayBoard(Board), nl,
												write('THE WINNER IS - '), playerTeamName(Player,TName), write(TName),nl,nl,
												write(' Blue Team '), write(Points1), write(' POINTS!'),nl,
												write(' Red Team '), write(Points2), write(' POINTS!'),nl,nl,
												write('Press some key and . to continue'), read(_).
	
/*
displayBoardInfo
Displays information about the board cells
*/
displayBoardInfo :- write('System    Type'),nl,
					write('     Ships'),nl,
					write(' Team     Dom'),nl,
					write('System:(H) HomeBase  (S) Star  (N) Nebula  (B) Blackhole'), nl,
					write('Type:  (0-3) Planets  (R) Red  (B) Blue'), nl,
					write('Team:  (1) Red team (2) Blue team'), nl,
					write('Dom:   (C) Colony  (T) Trade Center'), nl,nl.

/*
error
Displays the error Message T
*/
					
error(T) :- write('WARNING'), nl, errorMsg(T), nl, nl.
errorMsg(1) :- write('Invalid movement').
errorMsg(2) :- write('Could not add dominion').
errorMsg(3) :- write('Could not load players, wrong board').
errorMsg(4) :- write('Values must be numbers > 0').
errorMsg(5) :- write('Wrong Arguments').
errorMsg(6) :- write('You have Placed 4 Trades already').


									
									
									