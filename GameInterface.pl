/*************************
*		INTERFACE		 *
*************************/

clearscreen :- write('\e[2J').

%INPUTS

game_settings(Board,P1,P2) :- 	/*clearscreen,*/
								board_settings(Board),
								loadPlayers(Board,P1,P2).
								
board_settings(Board) :- 	write('BOARD SETTINGS'), nl,
							write('BoardsId (1): '), read(BoardId), 
							board(BoardId,Board),
							nl.
							
moveShip_settings(Ri,Ci,Rf,Cf) :- 	write('CHOOSE SHIP'), nl,
									write('From Row'), read(Ri),
									write('From Column'),read(Ci),
									write('CHOOSE DESTINATION'),nl,
									write('To Row'), read(Rf),
									write('To Column'),read(Cf), nl,
									number(Ri),number(Ci),number(Rf),number(Cf).
										
addDominion_settings(Type) :- 	write('Colony(C) or Trade(T): '),read(Type), nl,
								(Type == 'C' ; Type == 'T').
	
%OUTPUTS
	
displayTurn(Board,Player,Moves) :-	/*clearscreen,*/
									write('NEW TURN - '),
									displayTeamName(Player),
									displayBoard(Board),
									displayPlayerInfo(Player),
									displayPossibleMoves(Player,Moves).
									
displayPossibleMoves(P,M) :- 		playerGetShips(P,S) , write('POSSIBLE MOVES:'),nl,
									displayMovesAux(S,M),nl, nl.
displayMovesAux([],_).
displayMovesAux(_,[]).
displayMovesAux([S|Sn],[M|Mn]) :- 	write('SHIP - '), write(S), write('    '),
									displayList(M),nl, !,
									displayMovesAux(Sn,Mn).
								
								
									
displayWinner(Player, Points) :-	nl, write('THE WINNER IS - '), displayTeamName(Player), 
									write(' WITH '), write(Points), write(' POINTS!'),nl .
									
error(T) :- write('WARNING'), nl, errorMsg(T), nl, nl.
errorMsg(1) :- write('Invalid movement').
errorMsg(2) :- write('Could not add dominion').
errorMsg(3) :- write('Could not load players, wrong board').
errorMsg(4) :- write('Values must be numbers > 0').
									
									
									