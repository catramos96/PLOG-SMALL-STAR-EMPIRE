/************************
*		MATRIX			*
************************/
:- use_module(library(lists)).

matrix([[1,2,3],[4,5,6],[7,8,9]]).

%GETS
getCell(Mat,Row,Column,Value) :- nth1(Row, Mat, ARow), nth1(Column, ARow, Value).	

%SETS
setCellValue(M,R,C,V,F) :-	setCell(M,R,C,1,1,V,[],F).

setCell([],_,_,_,_,_,F,F).
setCell([L1|L2],R,C,Nr,Nc,V,T,Mf) :- 	R is Nr, ! , setCellRow(L1,C,Nc,V,[],Rf),
										append(T,[Rf|[]],T2),
										Nr1 = Nr + 1,
										setCell(L2,R,C,Nr1,Nc,V,T2,Mf).	
										
setCell([L1|L2],R,C,Nr,Nc,V,T,Mf) :- 	append(T,[L1|[]],T2),
										Nr1 = Nr + 1,
										setCell(L2,R,C,Nr1,Nc,V,T2,Mf).
										
setCellRow([],_,_,_,F,F).
setCellRow([_|L2],C,Nc,V,T,F) :- 	C is Nc ,!, append(T,[V|[]],T2),
									Nc1 = Nc + 1,
									setCellRow(L2,C,Nc1,V,T2,F).
									
setCellRow([L1|L2],C,Nc,V,T,F) :- 	append(T,[L1|[]],T2),
									Nc1 = Nc + 1,
									setCellRow(L2,C,Nc1,V,T2,F).		

%DISPLAYS									
displayM([L1|L2]) :- 	displayList(L1),nl, displayM(L2).				
displayM([]).

/************************
*		 LIST			*
************************/

list([1,2,3,4,5]).		%TO_TEST

%ADD
addList(E,L1,L2) :- 	append(L1,[E|[]],L2).

%REMOVE
remList(E,L1,L2) :-		append(_Y,[E|_Z],L1),append(_Y,_Z,L2).

%SET
setList(E,L1,C,L2) :- 	setCellRow(L1,C,1,E,[],L2).	

%GET
getListElem(L1,P,E) :- 	nth1(P,L1,E).

%DISPLAY
displayList([L1|L2]) :- write(L1),write(' '),displayList(L2).
displayList([]).