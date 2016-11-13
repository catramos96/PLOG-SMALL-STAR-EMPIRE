/********************************************
************ SMALL STAR EMPIRE **************
*********************************************/

:-include('Board.pl').
:-include('Player.pl').	
:-include('GameFunctionalities.pl')	.
:-include('GameInterface.pl').	
:-include('Scores.pl').		
:- use_module(library(random)).	
														
/************************
*	      GAME			*
************************/
	

play(Board,Nivel,1,P1i,P2i,P1f,P2f,FinalBoard) :- 	turn(Board,Nivel,P1i,BoardT,P1t), !,		
													play(BoardT,Nivel,2,P1t,P2i,P1f,P2f,FinalBoard) .
												
play(Board,Nivel,2,P1i,P2i,P1f,P2f,FinalBoard) :- 	turn(Board,Nivel,P2i,BoardT,P2t), !,
													play(BoardT,Nivel,1,P1i,P2t,P1f,P2f,FinalBoard).											
play(Board,_,_,P1,P2,P1,P2,Board).
								
game :- menu(Choice), Choice is 1,
		game_settings(Board,Nivel,Mode), !,
		loadPlayers(Board,Mode,P1,P2), !,
		random(1,3,Team), !,
		play(Board,Nivel,Team,P1,P2,P1f,P2f,Bf), !,
		winner(Bf,P1f,P2f), game.
		
game :- clearscreen.