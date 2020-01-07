include "alldifferent.mzn";
int: A = 1;
int: B = 2;

% Array que indica el orden de aplicacion de las capas
% En cada elemento se almacena la posición que ocupara
%    en la lista resultante.
array [1..2,1..9] of var 1..18: E;
constraint alldifferent (E);

% Restriccion a)
constraint (
    abs(E[A,2]-E[A,1]) != 1 /\
    abs(E[A,2]-E[A,5]) != 1 /\
    abs(E[A,2]-E[A,9]) != 1 /\
    abs(E[A,2]-E[B,4]) != 1
);
                                                                                  
% Restriccion b)
constraint forall (i in 1..9) (
    abs(E[A,i] - E[A,7]) != 1 
);

% Restriccion c)
constraint(
    abs(E[A,4] - E[B,4]) > 4
);

% Restriccion d)
constraint(
    abs(E[A,8] - E[B,8]) == 2
);

% e)
constraint(
    abs(E[A,5] - E[B,5]) == 1
);

% f)
constraint exists(i in 1..2)(
    abs(E[A,4] - E[i,1]) == 1 \/
    abs(E[A,4] - E[i,9]) == 1
);

% g)
constraint(
    abs(E[A,6] - E[A,7]) != 1
);

% h)
constraint(
    (
        abs(E[A,5] - E[B,4]) == 1 \/
        abs(E[A,5] - E[B,8]) == 1 \/
        abs(E[A,5] - E[A,2]) == 1 \/
        abs(E[A,5] - E[A,3]) == 1 \/
        abs(E[A,5] - E[A,7]) == 1
    ) /\
    abs(E[A,6] - E[B,5]) != 1
);

% i)
constraint forall(i,j in 1..9 where i > j)(
    E[A,i] > E[A,j]
);

% j)
constraint forall(i,j in 1..6 where i > j)(
    E[B,i] < E[B,j]
);

output 
%    [if i = 1 then "EA" else "EB" endif ++ show(j)++"\t"
%    | k in 1..18 , i in 1..2 ,j in 1..9 where fix(E[i,j]) == k ]; 

[show(E[i,j]) ++ "\t" ++ if j = 9 then "\n" else "" endif | i in 1..2 ,j in 1..9 ];

% 2)  
%solve minimize  (abs(E[A,8]-E[A,9])+abs(E[B,1] - E[B,2]));

% 3)
%solve maximize  (abs(E[A,3]-E[B,9]) - abs(E[A,7] - E[B,7]));
 