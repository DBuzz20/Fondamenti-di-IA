four_queens(Ris):-
    %imposto la popolazione inziale
    four_queens([[1,2,3,4],[1,2,3,4]],Ris).

four_queens(Population, Ris):-
    writeln('Popolazione attuale:'),
    writeln(Population),
    %Collisioni è una lista contenente il numero di collisioni degli individui
    classificazione(Population,Collisioni),
    min_list(Collisioni,Min),
    Min =\= 0,
    sum_list(Collisioni,Sum),
    selection(Population,Sum,Temp),
    length(Temp,Len),
    %se la selection non seleziona alcun individuo,riprendo la popolazione precedente
    (Len =\= 0 -> Scelti = Temp ; Scelti = Population),
    writeln('Individui selezionati:'),
    writeln(Scelti),
    crossover(Scelti,Scelti_cross),
    mutation(Scelti_cross, New_pop),
    writeln('Nuova generazione:'),
    writeln(New_pop),
    writeln(''),
    four_queens(New_pop,Ris).

four_queens(Population, Ris):-
    %se nella popolazione attuale,c'è una configurazione la cui fitness è 0...
    classificazione(Population,Collisioni),
    min_list(Collisioni,Min),
    Min = 0,
    %...ne prendo l'indice (Index) e risalgo così all'array corretto
    nth1(Index,Collisioni,0),
    nth1(Index,Population,Ris),
    writeln(''),
    writeln('Soluzione: '),
    writeln(Ris).

%----------
%seleziono gli individui della popolazione tramite probabilita condizionata
%dal numero di collisioni che presentano rispetto al totale
selection([],_,[]).

selection([Q|List],Tot, Ris):-
    fitness(Q,Coll_individuo),
    %gli individui che hanno meno collisioni hanno più probabilità di essere selezionati
    P is 1 - Coll_individuo/Tot,
    %maybe(P) -> con probabilità P,esegui le righe successive tra parentesi
    (maybe(P) ->Ris = [R|Rlist],
                R = Q,
                selection(List, Tot, Rlist)
                ;
                selection(List, Tot, Ris) ).

%----------

%fa crossover fra elementi della lista due a due. alla fine ritorna l'unione tra la vecchia
%popolazione ed i nuovi individui generati dal crossover.
crossover([],[]).

crossover([Q|List], Ris) :-
    crossover_aux(Q,List,Crossings),
    crossover(List, R2),
    union([Q|R2],Crossings,Ris).

crossover_aux(_,[],[]).

%Q e C sono due individui diversi della popolazione
crossover_aux(Q,[C|List],Ris):-
    cross(Q,C,C1,C2),
    crossover_aux(Q,List, Coda),
    union([C1,C2],Coda,Ris).

%crossover_aux valevole per gli ultimi elementi della lista
crossover_aux(Q,[C|List],Ris):-
    \+ cross(Q,C,_,_), %true se cross(Q,C,_,_) non può essere provato:lista vuota o 1 elem.
    crossover_aux(Q,List, Coda),
    Ris=Coda.

%prendo i primi due elementi di Q,controllo che non siano uguali agli ultimi due di C e
%li unisco in un unico individuo. Lo stesso accade poi tra ultimi due di Q e primi due di C
cross(Q,C, R1,R2) :-
    [Q1,Q2,Q3,Q4] = Q,
    [C1,C2,C3,C4] = C,
    %controllo che siano diversi per evitare di avere due regine su stessa riga
    Q1 =\= C3,
    Q1 =\= C4,
    Q2 =\= C3,
    Q2 =\= C4,
    R1 = [Q1,Q2,C3,C4],
    R2 = [C1,C2,Q3,Q4].

%----------

% Mutation : scambio di posto tra loro due elementi scelti casualmente in un individuo
mutation([],[]).
mutation([Q|QList], [Q,X|RList]):-
    length(Q,L),
    random_between(1,L,Rand1),
    random_between(1,L,Rand2),
    swap(Q,Rand1,Rand2,X),
    mutation(QList,RList).

swap(List,IndexA,IndexB,X):-
    %nth1 seleziona l'elemento nella lista List di indice Index
    nth1(IndexA,List, E1),
    nth1(IndexB,List, E2),
    %inserisco E1 in posizione IndexB e viceversa per E2 e IndexA(li scambio)
    replace(List,IndexB,E1,Y),
    replace(Y,IndexA,E2,X).

replace([],_,_,[]).

%replace per il primo elemento della lista
replace([_|List],Index,Element,[N|NewList]):-
    Index = 1,
    N = Element,
    I is Index-1,
    replace(List,I,Element,NewList).

%replace per gli elementi successivi
replace([L|List],Index,Element,[N|NewList]):-
    Index =\= 1,
    N = L,
    I is Index-1,
    replace(List,I,Element,NewList).

%----------
%
%la fitness function la definisco come il numero di collisioni che trovo in una
%configurazione,meno ne ho, migliore considero la disposizione
fitness([], 0).
fitness([Q|Qlist], Ris) :-
    noattack(Q, Qlist, 1, Collisioni),
    fitness(Qlist, R2),
    Ris is R2 + Collisioni.

%permette di iterare il calcolo della fitness su tutti gli individui della popolazione
classificazione([],[]).
classificazione([QList|List], [R1|Ris]):-
    fitness(QList, R1),
    classificazione(List, Ris).

noattack(_,[], _, 0).

%se la regina in posizione Q non minaccia diagonalmente un'altra regina, Ris=R2
noattack(Q,[Q1|Qlist],Dist,Ris) :-
  Q =\= Q1,
  Temp is abs(Q1-Q),
  Temp =\= Dist, %due regine non si minacciano in diagonale
  New_dist is Dist + 1,
  noattack(Q,Qlist,New_dist, R2),
    Ris is R2.

%se la regina in posizione Q minaccia diagonalmente un'altra regina, Ris=R2+1
noattack(Q,[Q1|Qlist],Dist,Ris) :-
  Q =\= Q1,
  Temp is abs(Q1-Q),
  Temp = Dist, %due regine si minacciano in diagonale
  New_dist is Dist + 1,
  noattack(Q,Qlist,New_dist, R2),
    Ris is R2 + 1.