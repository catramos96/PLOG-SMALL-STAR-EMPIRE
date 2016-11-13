/************************
*	MATRIX AND LISTS	*
************************/

:- use_module(library(lists)).

matrix([[1,2,3],[4,5,6],[7,8,9]]).
list([1,2,3,4,5]).		

/*
getCell (Matrix)
Returns the Element in the Row and Column of the Matrix
*/
getCell(Matrix,Row,Column,Value) :- nth1(Row, Matrix, ARow), nth1(Column, ARow, Value).	

/*
setCellValue (Matrix)
Returns a MatrixF where the element in the Row and Column of the original Matrix was set by Value
*/
setCellValue(Matrix,Row,Column,Value,MatrixF) :-	setCell(Matrix,Row,Column,1,1,Value,[],MatrixF).

setCell([],_,_,_,_,_,F,F).
setCell([L1|L2],R,C,Nr,Nc,V,T,Mf) :- 	R is Nr, ! , setCellRow(L1,C,Nc,V,[],Rf),	/*If the counter Nr is R then it's processing*/
										append(T,[Rf|[]],T2),						/*The pretended row*/
										Nr1 = Nr + 1,
										setCell(L2,R,C,Nr1,Nc,V,T2,Mf).	
										
setCell([L1|L2],R,C,Nr,Nc,V,T,Mf) :- 	append(T,[L1|[]],T2),
										Nr1 = Nr + 1,
										setCell(L2,R,C,Nr1,Nc,V,T2,Mf).
										
setCellRow([],_,_,_,F,F).
setCellRow([_|L2],C,Nc,V,T,F) :- 	C is Nc ,!, append(T,[V|[]],T2),				/*If the counder Nc is C then its processing*/
									Nc1 = Nc + 1,									/*the pretended column*/
									setCellRow(L2,C,Nc1,V,T2,F).
									
setCellRow([L1|L2],C,Nc,V,T,F) :- 	append(T,[L1|[]],T2),
									Nc1 = Nc + 1,
									setCellRow(L2,C,Nc1,V,T2,F).		

/*
displayMatrix (Matrix)
*/									
displayMatrix([L1|L2]) :- 	displayList(L1),nl, displayMatrix(L2).				
displayMatrix([]).


/*
addList (List)
Returns ListF the append of ListI with Element
*/
addList(Element,ListI,ListF) :- 	append(ListI,[Element|[]],ListF).

/*
remList (List)
Returns ListF, equal to ListI but without Element
*/
remList(Element,ListI,ListF) :-		append(_Y,[Element|_Z],ListI),append(_Y,_Z,ListF).

/*
setList (List)
Returns ListF a list equal to ListI but the element in the position Position was set with Element
*/
setList(Element,ListI,Position,ListF) :- 	setCellRow(ListI,Position,1,Element,[],ListF).	

/*
getListElem (List)
*/
getListElem(List,Position,Element) :- 	nth1(Position,List,Element).

/*
displayList (List)
*/
displayList([L1|L2]) :- write(L1),write(' '),displayList(L2).
displayList([]).