/************************
*	FUNCTIONALITIES		*
************************/

:-include('GameFunctionalitiesAux.pl').

/*
loadPlayers
Load the two players according to the selected Mode
*/
loadPlayers(Board,Mode,Player1,Player2) :- 	getCell(Board,HomeRow1,HomeColumn1,[6,0,HomeNShips1]),		
											getCell(Board,HomeRow2,HomeColumn2,[6,2,HomeNShips2]),
											createPlayer(1,HomeNShips1,[HomeRow1|[HomeColumn1|[]]],PlayerT1),
											createPlayer(2,HomeNShips2,[HomeRow2|[HomeColumn2|[]]],PlayerT2),
											loadMode(Mode,PlayerT1,PlayerT2,Player1,Player2).

loadMode(1,Player1I,Player2I,Player1F,Player2F) :- playerSetType(Player1I,'H',Player1F),playerSetType(Player2I,'H',Player2F).
loadMode(2,Player1I,Player2I,Player1F,Player2F)	:- 	random(1,3,R),
													((R is 1, playerSetType(Player1I,'C',Player1F),playerSetType(Player2I,'H',Player2F)) ;
													 (R is 2, playerSetType(Player1I,'H',Player1F),playerSetType(Player2I,'C',Player2F))).
loadMode(3,Player1I,Player2I,Player1F,Player2F)	:- playerSetType(Player1I,'C',Player1F),playerSetType(Player2I,'C',Player2F).
								
								
/*
turn
Update the valid ships and get the Possible Moves to make a new move.
If there are no more possible moves it returns false (Game Over).
*/							
turn(BoardI,Level,PlayerI,BoardF,PlayerF) :- 	updateValidShips(BoardI,PlayerI,Pt1), !,
												getPossibleMoves(BoardI,Pt1,AllMoves), !,
												AllMoves \= [],									/*Game Over if M = []*/
												displayTurn(BoardI,Pt1,AllMoves), 
												make_move(BoardI,Level,AllMoves,Pt1,BoardF,PlayerF).
		
		
/*
make_move
Makes a move and adds a control to the moved cell.
*/		
make_move(BoardI,Level,AllMoves,PlayerI,BoardF,PlayerF) :-	movement(Level,BoardI,PlayerI,AllMoves,RowI,ColumnI,RowF,ColumnF), !,								
															addControl(Level,BoardI,PlayerI,RowF,ColumnF,Tmp1,PlayerT), !,
															setShip(Tmp1,RowF,ColumnF,1,Tmp2), !,
															setShip(Tmp2,RowI,ColumnI,-1,BoardF), !,
															playerSetShip(PlayerT,[RowI|[ColumnI|[]]],[RowF|[ColumnF|[]]],PlayerF).	
												
make_move(BoardI,Level,AllMoves,PlayerI,BoardF,PlayerF) :- make_move(BoardI,Level,AllMoves,PlayerI,BoardF,PlayerF).

/*
movement
Gets the Ship position [Ri,ColumnI] and destination cell [Rf,ColumnF] conforming the level.
True if the movement is valid.
*/														
movement(_,_,Player,AllMoves,RowI,ColumnI,RowF,ColumnF) :- 	playerGetType(Player,'H'),
															moveShip_settings(RowI,ColumnI,RowF,ColumnF),				%PERSON
															validMove(AllMoves,Player,RowI,ColumnI,RowF,ColumnF).

movement(1,_,Player,AllMoves,RowI,ColumnI,RowF,ColumnF) :-	playerGetType(Player,'C'), 						%COMPUTER
															getRandShip(Player,AllMoves,RowI,ColumnI,ShipMoves),
															getRandMove(ShipMoves,RowF,ColumnF) .								

movement(2,Board,Player,AllMoves,RowI,ColumnI,RowF,ColumnF) :-	playerGetType(Player,'C'),						%COMPUTER
																getPossibleMovesValued(Board,Player,AllMoves,ValuedList),
																getBestMove(ValuedList,Ship,Pos),
																playerGetShips(Player,ListShips), 
																getListElem(ListShips,Ship,[RowI|[ColumnI|[]]]),
																getCell(AllMoves,Ship,Pos,[RowF|[ColumnF|[]]]) .													
											
movement(Level,Board,Player,AllMoves,RowI,ColumnI,RowF,ColumnF) :- 	error(4), movement(Level,Board,Player,AllMoves,RowI,ColumnI,RowF,ColumnF).


/*
addControl
Adds a control dominated by the players team to the board.
*/								
addControl(Level,BoardI,PlayerI,Row,Column,BoardF,PlayerF) :- 	addControlAux(Level,PlayerI,BoardI,Row,Column,Type), !,									%SUCCESS
																playerGetTeam(PlayerI,Team),	
																\+ (Type == 'T', playerGetTrades(PlayerI,Trades),length(Trades,L), L >= 4,error(6)),
																setDominion(BoardI,Team,Row,Column,Type,BoardF), !,
																playerAddControl(PlayerI,Type,[Row|[Column|[]]],PlayerF).		
										
addControl(Level,BoardI,PlayerI,Row,Column,BoardF,PlayerF) :- error(2), addControl(Level,BoardI,PlayerI,Row,Column,BoardF,PlayerF).					%FAIL
			

addControlAux(_,Player,_,_,_,Type) :- 	playerGetType(Player,'H'),
										addDominion_settings(Type) .		

addControlAux(Level,Player,BoardI,Row,Column,Type) :- 	playerGetType(Player,'C'),
														getAdjCells(BoardI,Row,Column,AdjCells),
														playerGetTeam(Player,MyTeam),
														chooseType(Level,BoardI,Player,AdjCells,MyTeam,Type) .							