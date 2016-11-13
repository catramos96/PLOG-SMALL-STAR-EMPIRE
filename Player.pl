/************************
*		PLAYER			*
************************/
			
player1 :- 	[1,0,[],[],[]].		/*[Team,Type,TradesPositions,ColoniesPositions,ShipsPositions]*/
player2 :-	[2,0,[],[],[]].

/*
createPlayer
creates a player with Team and NShips in the position Base
*/
createPlayer(Team,NShips,Base,P) :-	playerAddBaseShips([Team,' ',[],[],[]],NShips,Base,P).
										
playerAddBaseShips(PlayerI,NShips,Base,PlayerF) :- 	NShips \= 0,
													playerAddShip(PlayerI,Base,PlayerT), N1 is NShips-1,
													playerAddBaseShips(PlayerT,N1,Base,PlayerF).

playerAddBaseShips(PlayerI,_,_,PlayerI).
	
/*
Get Player's Information
*/
playerTeamName(P,'BLUE TEAM') :- 	playerGetTeam(P,T), T is 1.

playerTeamName(P,'RED TEAM') :-	playerGetTeam(P,T), T is 2.	
					
playerGetTeam(Player,Team) :-		getListElem(Player,1,Team).
playerGetType(Player,Type) :-		getListElem(Player,2,Type).
playerGetTrades(Player,Trades) :- 	getListElem(Player,3,Trades).
playerGetColonies(Player,Colonies) :- 	getListElem(Player,4,Colonies).
playerGetShips(Player,Ships) :- 	getListElem(Player,5,Ships).

getPosition([Row|[Column|[]]],Row,Column).
playerTerritory(Player, List) :- getListElem(Player,3,Trade), getListElem(Player,4,Colony), append(Colony, Trade, List) .	

/*
Sets Player's Information
*/
playerSetShip(PlayerI,ShipPosI,ShipPosF,PlayerF) :-	playerRemShip(PlayerI,ShipPosI,Pt) , playerAddShip(Pt,ShipPosF,PlayerF).
playerSetType(PlayerI,Type,PlayerF) :- setList(Type,PlayerI,2,PlayerF).

/*
Ads Player's positions
*/
playerAddControl(PlayerI,Type,Position,PlayerF) :-	Type == 'C', !,							
										playerAddColony(PlayerI,Position,PlayerF).										
playerAddControl(PlayerI,Type,Position,PlayerF) :-	Type == 'T', !,
										playerAddTrade(PlayerI,Position,PlayerF).
playerAddControl(PlayerI,_,_,PlayerI).																
										
playerAddTrade(PlayerI,Position,PlayerF) :- 	getListElem(PlayerI,3,Tr), addList(Position,Tr,Trf), setList(Trf,PlayerI,3,PlayerF).	
playerAddColony(PlayerI,Position,PlayerF) :- 	getListElem(PlayerI,4,C), addList(Position,C,Cf), setList(Cf,PlayerI,4,PlayerF).
playerAddShip(PlayerI,Position,PlayerF) :- 	getListElem(PlayerI,5,S), addList(Position,S,Sf), setList(Sf,PlayerI,5,PlayerF).

/*
playerRemShip
remove a ship with Position of the shipsPositions in the player
*/
playerRemShip(PlayerI,Position,PlayerF) :-	playerGetShips(PlayerI,Ships), remList(Position,Ships,ShipsF), setList(ShipsF,PlayerI,5,PlayerF).	

/*
hasShip
true if the player has a ship with the position [Row,Column]
*/
hasShip(PlayerI,Row,Column) :- 	playerGetShips(PlayerI,Ships),
								member([Row|[Column|[]]],Ships).

/*
displayPlayerInfo
displays the information about the player
*/
displayPlayerInfo(Player) :- 	write('TRADES: '),nl, playerGetTrades(Player,Trades), displayList(Trades), nl, nl,
								write('COLONIES: '), nl ,playerGetColonies(Player,Colonies),displayList(Colonies), nl, nl,
								write('SHIPS: '), nl, playerGetShips(Player,Ships), displayList(Ships),nl, nl.