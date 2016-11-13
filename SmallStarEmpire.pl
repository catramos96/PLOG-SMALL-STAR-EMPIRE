/********************************************
************ SMALL STAR EMPIRE **************
*********************************************/

:-include('Board.pl').
:-include('Player.pl').	
:-include('GameFunctionalities.pl')	.
:-include('GameInterface.pl').	
:-include('Scores.pl').		
:- use_module(library(random)).	
													

/*
play(BoardI,Nivel,Team,Player1I,Player2I,Player1F,Player2F,BoardF)
Predicate that does a turn of the initial player with the team T (PlayerTI) returning a temporary Board (BoardT) and Player (PlayerTT)
Gives the other player's Team the chance to play with the modified Board and Player.
If the players turn is false, then the Final Board and Players are equal to the Initial Ones
*/
play(BoardI,Nivel,1,Player1I,Player2I,Player1F,Player2F,BoardF) :- 	turn(BoardI,Nivel,Player1I,BoardT,Player1T), !,		
																	play(BoardT,Nivel,2,Player1T,Player2I,Player1F,Player2F,BoardF) .
												
play(BoardI,Nivel,2,Player1I,Player2I,Player1F,Player2F,BoardF) :- 	turn(BoardI,Nivel,Player2I,BoardT,Player2T), !,
																	play(BoardT,Nivel,1,Player1I,Player2T,Player1F,Player2F,BoardF).											
play(Board,_,_,Player1,Player2,Player1,Player2,Board).
								
								
/*
game
Predicate that does the game cycle from the inicial menu to the game over stage.
If the Choice in the inicial menu is diferent from 1 ( = Exit) then it leaves the cycle.
*/								
game :- menu(Choice), Choice is 1,												/*Inicial Menu*/
		game_settings(BoardI,Nivel,Mode), !,									/*Game Options*/
		loadPlayers(BoardI,Mode,Player1,Player2), !,							/*Create Players*/
		random(1,3,StartTeam), !,												/*Choose Team to start first*/
		play(BoardI,Nivel,StartTeam,Player1,Player2,Player1F,Player2F,BoardF), !,/*Play*/
		winner(BoardF,Player1F,Player2F), game.									/*Game Over Scores*/
		
game :- clearscreen.