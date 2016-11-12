/********************************************
************ SMALL STAR EMPIRE **************
*********************************************/

:-include('Board.pl').
:-include('Player.pl').	
:-include('GameFunctionalities.pl')	.
:-include('GameInterface.pl').	
:-include('Scores.pl').			
														
/************************
*	      GAME			*
************************/
	

play(Board,1,P1i,P2i,P1f,P2f,FinalBoard) :- 	turn(1,Board,P1i,BoardT,P1t), !,			/*TEMPORARIO : acrescentado o modo de jogo(humano ou maquina) */
												play(BoardT,2,P1t,P2i,P1f,P2f,FinalBoard) .
												
play(Board,2,P1i,P2i,P1f,P2f,FinalBoard) :- 	turn(1,Board,P2i,BoardT,P2t), !,
												play(BoardT,1,P1i,P2t,P1f,P2f,FinalBoard).											
play(Board,_,P1,P2,P1,P2,Board).
								
game :- game_settings(Board,P1,P2), !,
		play(Board,1,P1,P2,P1f,P2f,Bf), !,
		winner(Bf,P1f,P2f).