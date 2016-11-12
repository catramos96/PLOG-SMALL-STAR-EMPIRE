/************************
*	FUNCTIONALITIES		*
************************/

:-include('GameRules.pl').
:-include(library(random)).

loadPlayers(Board,P1,P2) :- 	getCell(Board,R1,C1,[6,0,N1]),								
								createPlayer(1,N1,[R1|[C1|[]]],P1),
								getCell(Board,R2,C2,[6,2,N2]),
								createPlayer(2,N2,[R2|[C2|[]]],P2).						

								
								
turn(Mode,Board,Pi,FinalBoard,Pf) :- 	updateValidShips(Board,Pi,Pt1), !,
										getPossibleMoves(Board,Pt1,AllMoves), !,
										AllMoves \= [],									/*Game Over if M = []*/
										displayTurn(Board,Pt1,AllMoves), 
										make_move(Mode,Board,AllMoves,Pt1,FinalBoard,Pf).
		
		
		
make_move(Mode,Board,AllMoves,Pi,FinalBoard,Pf) :-	movement(Mode,Pi,AllMoves,Ri,Ci,Rf,Cf), !,	%SUCCESS							
													addControl(Mode,Board,Pi,Rf,Cf,Tmp1,Pt), !,
													setShip(Tmp1,Rf,Cf,1,Tmp2), !,
													setShip(Tmp2,Ri,Ci,-1,FinalBoard), !,
													playerSetShip(Pt,[Ri|[Ci|[]]],[Rf|[Cf|[]]],Pf).	
												
make_move(Mode,Board,AllMoves,Pi,FinalBoard,Pf) :- make_move(Mode,Board,AllMoves,Pi,FinalBoard,Pf).	%FAIL
							
							
										
addControl(Mode,Board,Pi,Rf,Cf,Final,Pf) :- addControlAux(Mode,Pi,Board,Rf,Cf,Type), !,									%SUCCESS
											playerGetTeam(Pi,Team),								
											setDominion(Board,Team,Rf,Cf,Type,Final), !,
											playerAddControl(Pi,Type,[Rf|[Cf|[]]],Pf).		
										
addControl(Mode,Board,Pi,Rf,Cf,Final,Pf) :- error(2), addControl(Mode,Board,Pi,Rf,Cf,Final,Pf).					%FAIL
			

addControlAux(0,_,_,_,_,Type) :- addDominion_settings(Type) .		

addControlAux(1,Player,Board,R,C,Type) :- 	getAdjCells(Board,R,C,AdjCells),
											playerGetTeam(Player,MyTeam),
											chooseType(Player,AdjCells,MyTeam,Type).							
							
chooseType(Player,AdjCells,MyTeam,Type)	:- 	(MyTeam == 1, member(AdjCells,[_|[2|[]]]) ) ;
											(MyTeam == 2, member(AdjCells,[_|[1|[]]]) ) ,
											getListElem(Player,2,Trades),
											length(Trades,Length), Length < 4, 	/* Ainda posso colocar Trades*/
											Type = 'T'.
chooseType(_,_,_,Type) :- Type = 'C'.						
			
movement(0,Player,AllMoves,Ri,Ci,Rf,Cf) :- 	moveShip_settings(Ri,Ci,Rf,Cf),				%PERSON
											validMove(AllMoves,Player,Ri,Ci,Rf,Cf).
movement(0,Player,AllMoves,Ri,Ci,Rf,Cf) :- 	error(4), movement(0,Player,AllMoves,Ri,Ci,Rf,Cf).

movement(1,Player,AllMoves,Ri,Ci,Rf,Cf) :-	getRandShip(Player,AllMoves,Ri,Ci,ShipMoves),
											getRandMove(ShipMoves,Rf,Cf) .								%COMPUTER
movement(1,_,_,_,_,_,_) :- write('erro?'),nl .

getRandShip(Player,AllMoves,R,C,ShipMoves) :- 	playerGetShips(Player,Ships), 
												length(Ships,Length),
												X is Length +1,
												random(1,X,Rand), 
												nth1(Rand,Ships,Value),
												getPosition(Value,R,C),	/* posicao do barco aleatorio */
												nth1(Rand,AllMoves,ShipMoves) .	/* todos os movimentos do barco aleatorio */						

getRandMove(ShipMoves,R,C) :- 	length(ShipMoves, Length),
								X is Length +1,
								random(1,X,Rand),
								nth1(Rand,ShipMoves,[R|[C|[]]]) .