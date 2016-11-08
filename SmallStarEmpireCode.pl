/********************************************
************ SMALL STAR EMPIRE **************
*********************************************/

:-include('Player.pl').	
:-include('GameFunctionalities.pl')	.					
														
/************************
*	      GAME			*
************************/
				
game :- game_settings(Board,P1,P2),
		play(Board,P1,P2,P1f,P2f).


















