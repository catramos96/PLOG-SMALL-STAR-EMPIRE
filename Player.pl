/************************
*		PLAYER			*
************************/
			
player1 :- 	[1,0,[],[],[]].		
player2 :-	[2,0,[],[],[]].

%CREATE
createPlayer(Team,NShips,Base,P) :-	playerAddBaseShips([Team,' ',[],[],[]],NShips,Base,P).
										
playerAddBaseShips(Pi,NShips,Base,Pf) :- 	NShips \= 0,
											playerAddShip(Pi,Base,T), N1 is NShips-1,
											playerAddBaseShips(T,N1,Base,Pf).

playerAddBaseShips(Pi,_,_,Pi).
	
%GETS
playerTeamName(P,'BLUE TEAM') :- 	playerGetTeam(P,T), T is 1.

playerTeamName(P,'RED TEAM') :-	playerGetTeam(P,T), T is 2.	
					
playerGetTeam(Player,T) :-		getListElem(Player,1,T).
playerGetType(Player,T) :-		getListElem(Player,2,T).
playerGetTrades(Player,T) :- 	getListElem(Player,3,T).
playerGetColonies(Player,C) :- 	getListElem(Player,4,C).
playerGetShips(Player,S) :- 	getListElem(Player,5,S).

getPosition([R|[C|[]]],R,C).
playerTerritory(Player, List) :- getListElem(Player,3,Trade), getListElem(Player,4,Colony), append(Colony, Trade, List) .	

%SETS
playerSetShip(Pi,SPosi,SPosf,Pf) :-	playerRemShip(Pi,SPosi,Pt) , playerAddShip(Pt,SPosf,Pf).
playerSetType(PlayerI,Type,PlayerF) :- setList(Type,PlayerI,2,PlayerF).

%ADDS
playerAddControl(Pi,Type,Tpos,Pf) :-	Type == 'C', !,							
										playerAddColony(Pi,Tpos,Pf).										
playerAddControl(Pi,Type,Tpos,Pf) :-	Type == 'T', !,
										playerAddTrade(Pi,Tpos,Pf).
playerAddControl(Pi,_,_,Pi).																
										
playerAddTrade(Pi,TPos,Pf) :- 	getListElem(Pi,3,Tr), addList(TPos,Tr,Trf), setList(Trf,Pi,3,Pf).	
playerAddColony(Pi,CPos,Pf) :- 	getListElem(Pi,4,C), addList(CPos,C,Cf), setList(Cf,Pi,4,Pf).
playerAddShip(Pi,SPos,Pf) :- 	getListElem(Pi,5,S), addList(SPos,S,Sf), setList(Sf,Pi,5,Pf).

%REMOVE
playerRemShip(Pi,SPos,Pf) :-	playerGetShips(Pi,S), remList(SPos,S,Sf), setList(Sf,Pi,5,Pf).	

%CONFIRMATION
hasShip(Pi,Row,Column) :- 	playerGetShips(Pi,S),
								member([Row|[Column|[]]],S).

%DISPLAYS

displayPlayerInfo(Player) :- 	write('TRADES: '),nl, playerGetTrades(Player,Trades), displayList(Trades), nl, nl,
								write('COLONIES: '), nl ,playerGetColonies(Player,Colonies),displayList(Colonies), nl, nl,
								write('SHIPS: '), nl, playerGetShips(Player,Ships), displayList(Ships),nl, nl.