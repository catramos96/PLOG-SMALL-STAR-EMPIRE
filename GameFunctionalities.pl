/************************
*	FUNCTIONALITIES		*
************************/

:-include('GameRules.pl').
:- use_module(library(random)).

loadPlayers(Board,Mode,P1f,P2f) :- 	getCell(Board,R1,C1,[6,0,N1]),		
									getCell(Board,R2,C2,[6,2,N2]),
									createPlayer(1,N1,[R1|[C1|[]]],Pt1),
									createPlayer(2,N2,[R2|[C2|[]]],Pt2),
									loadMode(Mode,Pt1,Pt2,P1f,P2f).

loadMode(1,P1i,P2i,P1f,P2f) :- playerSetType(P1i,'H',P1f),playerSetType(P2i,'H',P2f).
loadMode(2,P1i,P2i,P1f,P2f)	:- playerSetType(P1i,'C',P1f),playerSetType(P2i,'H',P2f).
loadMode(3,P1i,P2i,P1f,P2f)	:- playerSetType(P1i,'C',P1f),playerSetType(P2i,'C',P2f).
								
								
								
turn(Board,Nivel,Pi,FinalBoard,Pf) :- 	updateValidShips(Board,Pi,Pt1), !,
										getPossibleMoves(Board,Pt1,AllMoves), !,
										AllMoves \= [],									/*Game Over if M = []*/
										displayTurn(Board,Pt1,AllMoves), 
										make_move(Board,Nivel,AllMoves,Pt1,FinalBoard,Pf).
		
		
		
make_move(Board,Nivel,AllMoves,Pi,FinalBoard,Pf) :-	movement(Nivel,Pi,AllMoves,Ri,Ci,Rf,Cf), !,	%SUCCESS							
													addControl(Board,Pi,Rf,Cf,Tmp1,Pt), !,
													setShip(Tmp1,Rf,Cf,1,Tmp2), !,
													setShip(Tmp2,Ri,Ci,-1,FinalBoard), !,
													playerSetShip(Pt,[Ri|[Ci|[]]],[Rf|[Cf|[]]],Pf).	
												
make_move(Board,Nivel,AllMoves,Pi,FinalBoard,Pf) :- make_move(Board,Nivel,AllMoves,Pi,FinalBoard,Pf).	%FAIL
							
							
										
addControl(Board,Pi,Rf,Cf,Final,Pf) :- addControlAux(Pi,Board,Rf,Cf,Type), !,									%SUCCESS
										playerGetTeam(Pi,Team),								
										setDominion(Board,Team,Rf,Cf,Type,Final), !,
										playerAddControl(Pi,Type,[Rf|[Cf|[]]],Pf).		
										
addControl(Board,Pi,Rf,Cf,Final,Pf) :- error(2), addControl(Board,Pi,Rf,Cf,Final,Pf).					%FAIL
			

addControlAux(Player,_,_,_,Type) :- 	playerGetType(Player,'H'),
										addDominion_settings(Type) .		

addControlAux(Player,Board,R,C,Type) :- 	playerGetType(Player,'C'),
											getAdjCells(Board,R,C,AdjCells),
											playerGetTeam(Player,MyTeam),
											chooseType(Board,Player,AdjCells,MyTeam,Type).							
							
chooseType(Board,Player,AdjCells,MyTeam,Type)	:- 	getTradePointsAux(Board,AdjCells,MyTeam,0,Num),
													Num > 0, 
													getListElem(Player,2,Trades),
													length(Trades,Length), Length < 4, 	/* Ainda posso colocar Trades*/
													Type = 'T'.
chooseType(_,_,_,_,Type) :- Type = 'C'.						
			
movement(Nivel,Player,AllMoves,Ri,Ci,Rf,Cf) :- 	playerGetType(Player,'H'),
												moveShip_settings(Ri,Ci,Rf,Cf),				%PERSON
												validMove(AllMoves,Player,Ri,Ci,Rf,Cf).

movement(Nivel,Player,AllMoves,Ri,Ci,Rf,Cf) :-	playerGetType(Player,'C'), 
												getRandShip(Player,AllMoves,Ri,Ci,ShipMoves),
												getRandMove(ShipMoves,Rf,Cf) .								%COMPUTER
												
movement(Nivel,Player,AllMoves,Ri,Ci,Rf,Cf) :- 	error(4), movement(Nivel,Player,AllMoves,Ri,Ci,Rf,Cf).
movement(Nivel,_,_,_,_,_,_) :- write('erro?'),nl .

