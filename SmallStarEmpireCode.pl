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
								play(FinalBoard,P1t,P2t,P1f,P2f).
				
game :- game_settings(Board,P1,P2),
		play(Board,P1,P2,P1f,P2f).


















