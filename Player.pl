/************************
*		PLAYER			*
************************/
			
player1 :- 	[1,[],[],[]].		
player2 :-	[2,[],[],[]].
	
/*:-include('Matrix.pl').*/

%CREATE
createPlayer(Team,NShips,Base,P) :-		playerAddBaseShips([Team,[],[],[]],NShips,Base,P).
										
playerAddBaseShips(Pi,NShips,Base,Pf) :- 	NShips \= 0,
											playerAddShip(Pi,Base,T), N1 is NShips-1,
											playerAddBaseShips(T,N1,Base,Pf).

playerAddBaseShips(Pi,_,_,Pi).
	
%GETS	
playerGetTeam([T|_],T).
playerGetShips(Pi,S) :- getListElem(Pi,4,S).
getPosition([R|[C|[]]],R,C).

%SETS
playerSetShip(Pi,SPosi,SPosf,Pf) :-	playerRemShip(Pi,SPosi,Pt) , playerAddShip(Pt,SPosf,Pf).

%ADDS
playerAddControl(Pi,Type,Tpos,Pf) :-	Type == 'C', !,							
										playerAddColony(Pi,Tpos,Pf).										
playerAddControl(Pi,Type,Tpos,Pf) :-	Type == 'T', !,
										playerAddTrade(Pi,Tpos,Pf).
playerAddControl(Pi,_,_,Pi).																
										
playerAddTrade(Pi,TPos,Pf) :- 	getListElem(Pi,2,Tr), addList(TPos,Tr,Trf), setList(Trf,Pi,2,Pf).	
playerAddColony(Pi,CPos,Pf) :- 	getListElem(Pi,3,C), addList(CPos,C,Cf), setList(Cf,Pi,3,Pf).
playerAddShip(Pi,SPos,Pf) :- 	getListElem(Pi,4,S), addList(SPos,S,Sf), setList(Sf,Pi,4,Pf).

%REMOVE
playerRemShip(Pi,SPos,Pf) :-	playerGetShips(Pi,S), remList(SPos,S,Sf), setList(Sf,Pi,4,Pf).	

%DISPLAYS
displayTeamName(P) :- 	playerGetTeam(P,T), T is 1, !,
						write('Blue Team'),nl.

displayTeamName(P) :-	playerGetTeam(P,T), T is 2, !,
						write('Red Team'),nl.

displayPlayerInfo([_|[Tr|[C|[S|[]]]]]) :- 	write('TRADES: '),nl, displayList(Tr), nl, nl,
											write('COLONIES: '), nl ,displayList(C), nl, nl,
											write('SHIPS: '), nl, displayList(S),nl, nl.