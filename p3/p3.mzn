int: E1A = 1;
int: E1B = 2;
int: E2A = 3;
int: E2B = 4;
int: E3A = 5;
int: E3B = 6;
int: E4A = 7;
int: E4B = 8;
int: E5A = 9;
int: E5B = 10;
int: E6A = 11;
int: E6B = 12;
int: E7A = 13;
int: E7B = 14;
int: E8A = 15;
int: E8B = 16;
int: E9A = 17;
int: E9B = 18;

% Array que indica el orden de aplicacion de las capas
array [1..18] of var 1..18: capas;

% Restriccion a)
constraint forall (i in 1..18 where capas[i] == E2A) (capas[i-1] != E1A /\ capas[i+1] != E1A
                                                   /\ capas[i-1] != E5A /\ capas[i+1] != E5A
                                                   /\ capas[i-1] != E9A /\ capas[i+1] != E9A
                                                   /\ capas[i-1] != E4B /\ capas[i+1] != E4B);
                                                   
% Restriccion b)
constraint forall (i in 1..18 where capas[i] == E2A) (capas[i-1] != E1A /\ capas[i+1] != E1A
                                                   /\ capas[i-1] != E5A /\ capas[i+1] != E5A
                                                   /\ capas[i-1] != E9A /\ capas[i+1] != E9A
                                                   /\ capas[i-1] != E4B /\ capas[i+1] != E4B);

