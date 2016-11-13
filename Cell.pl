/************************
*		CELLS			*
************************/

dominion(-1,' ',' ').	%NONE	
dominion(0,1,'C').		%TEAM_1_COLONY
dominion(1,1,'T').		%TEAM_1_TRADE
dominion(2,2,'C').		%TEAM_2_COLONY
dominion(3,2,'T').		%TEAM_2_TRADE

systemType(0,'S',0).		%ZeroPlanet
systemType(1,'S',1).		%OnePlanet
systemType(2,'S',2).		%TwoPlanet
systemType(3,'S',3).		%ThreePlanet
systemType(4,'N','R').		%NebulaRed
systemType(5,'N','B').		%NebulaBlue
systemType(6,'H',' ').		%HomeWorld
systemType(7,'B',' ').		

/*
get Cell Information (cell)
*/
getCellSystem([SystemId|[_|[_|[]]]],SystemId) :- systemType(SystemId,_,_).
getCellDominion([_|[DominionId|[_|[]]]],DominionId) :- dominion(DominionId,_,_).
getCellShips([_|[_|[NShips|[]]]],NShips).
getCellTeam(Cell,Team) :- 	getCellDominion(Cell,DominionId), dominion(DominionId,Team,_).

/*
set Cell Information (cell)
*/
setCellSystem([_|[DominionId|[NShips|[]]]],NewSt,[NewSt|[DominionId|[NShips|[]]]]).
setCellDominion([SystemId|[_|[NShips|[]]]],NewD,[SystemId|[NewD|[NShips|[]]]]).
setCellShips([SystemId|[DominionId|[_|[]]]],NewS,[SystemId|[DominionId|[NewS|[]]]]).

/*
incCellShips
increment cell ships
*/
incCellShips(Cell,NewCell) :- 	getCellShips(Cell,NShips),
								NewS is NShips + 1,
								setCellShips(Cell,NewS,NewCell).
	
/*
decCellShips
decrement cell ships
*/
decCellShips(Cell,NewCell) :- 	getCellShips(Cell,NShips),
								NewS is NShips - 1,
								setCellShips(Cell,NewS,NewCell).

/*
display Cell Information (Cell)
*/
displayDominion(I) :- dominion(I,P,C), write(P), write(' '),write(C).
displaySystem(I) :- systemType(I,A,B),write(A),write(' '),write(B).
displayCell([IDs|[IDp|[N|[]]]]) :- systemType(IDs,_,_), dominion(IDp,_,_), displaySystem(IDs),write(','),displayDominion(IDp),write(','),write(N).
