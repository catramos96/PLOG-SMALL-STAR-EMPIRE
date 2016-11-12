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
	

play(Board,Nivel,1,P1i,P2i,P1f,P2f,FinalBoard) :- 	turn(Board,Nivel,P1i,BoardT,P1t), !,		
													play(BoardT,Nivel,2,P1t,P2i,P1f,P2f,FinalBoard) .
												
play(Board,Nivel,2,P1i,P2i,P1f,P2f,FinalBoard) :- 	turn(Board,Nivel,P2i,BoardT,P2t), !,
													play(BoardT,Nivel,1,P1i,P2t,P1f,P2f,FinalBoard).											
play(Board,_,_,P1,P2,P1,P2,Board).
								
game :- game_settings(Board,Nivel,P1,P2), !,
		play(Board,Nivel,1,P1,P2,P1f,P2f,Bf), !,
		winner(Bf,P1f,P2f).