/*************************
*		INTERFACE		 *
*************************/

clearscreen :- write('\e[2J').

header(Title) :-	write('*****************************'),nl,
					write(Title), nl,
					write('*****************************'),nl,nl.
					
					
teste :- repeat,
		write('hello'),
		 read(X), X is 1.
					
menu(Choice) :-	clearscreen,
				header('SMALL STAR EMPIIRE'),
				write(' (1) PLAY'),nl,nl,
				write(' (2) EXIT'),nl,nl,
				read(Choice).

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
								
								
moveShip_settings(Ri,Ci,Rf,Cf) :- 	write('CHOOSE SHIP'), nl,
									write(' From Row'), read(Ri),
									write(' From Column'),read(Ci),
									write('CHOOSE DESTINATION'),nl,
									write(' To Row'), read(Rf),
									write(' To Column'),read(Cf), nl,
									number(Ri),number(Ci),number(Rf),number(Cf).
										
addDominion_settings(Type) :- 	write('CHOOSE DOMINION'),nl,
								write(' (C) Colony'),nl,
								write(' (T) Trade'),nl,
								read(Type), nl,
								(Type == 'C' ; Type == 'T').
	
%OUTPUTS
	
displayTurn(Board,Player,Moves) :-	clearscreen,
									playerTeamName(Player,TName),
									header(TName),
									displayBoard(Board),
									displayPlayerInfo(Player),
									displayPossibleMoves(Player,Moves).
									
displayPossibleMoves(P,M) :- 		playerGetShips(P,S) , write('POSSIBLE MOVES:'),nl,
									displayMovesAux(S,M),nl, nl.
displayMovesAux([],_).
displayMovesAux(_,[]).
displayMovesAux([S|Sn],[M|Mn]) :- 	write(' SHIP - '), write(S), write('    '),
									displayList(M),nl, !,
									displayMovesAux(Sn,Mn).
								
								
									
displayWinner(Board,Player,Points1,Points2) :-	clearscreen,
												header('GAME OVER'),
												displayBoard(Board), nl,
												write('THE WINNER IS - '), playerTeamName(Player,TName), write(TName),nl,nl,
												write(' Blue Team '), write(Points1), write(' POINTS!'),nl,
												write(' Red Team '), write(Points2), write(' POINTS!'),nl,nl,
												write('Press some key and . to continue'), read(_).
									
error(T) :- write('WARNING'), nl, errorMsg(T), nl, nl.
errorMsg(1) :- write('Invalid movement').
errorMsg(2) :- write('Could not add dominion').
errorMsg(3) :- write('Could not load players, wrong board').
errorMsg(4) :- write('Values must be numbers > 0').
errorMsg(5) :- write('Wrong Arguments').
errorMsg(6) :- write('You have Placed 4 Trades already').
									
									
									