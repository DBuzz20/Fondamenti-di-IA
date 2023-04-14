# Fondamenti-di-IA
Homework per il corso di Fondamenti di Intelligenza Artificiale

Corso di laurea in Ingegneria Informatica e Automatica, Sapienza Università di Roma

## A_star algorithm
L'Homework consisteva nel sviluppare un algoritmo basato su A* per vincere una versione basilare del gioco `frogger`.
Frogger è un semplice gioco che consiste nel far attraversare la strada ad una rana senza che questa venga colpita da una macchina.
Questo compito doveva essere automatizzato con l'uso dell'algoritmo A*, un algoritmo di ricerca sui grafi che,dato un nodo iniziale, trova il percorso più breve possibile per raggiungere uno specifico traguardo (in questo caso, una qualsiasi posizione dall'altra parte della strada).
A* utilizza una "stima euristica" che classifica ogni nodo attraverso una stima della strada migliore che passa attraverso tale nodo. Ad ogni step sceglie il nodo successivo in base a tale stima euristica.

## Genetic 4-queens
L'homework consisteva nel risolvere il problema delle 4 regine utilizzando il genetic algorithm in `Prolog`.
Il problema delle N regine consiste nel posizionare N regine su una scacchiera di dimensione NxN facendo in modo che non ci siano regine che si minaccino l'un l'altra.
Nel contesto dell'homework, viene fissato N=4.
L'algoritmo genetico è invece un algoritmo che, partendo da una popolazione inziale di possibili soluzioni, prima le valuta, selezionando dalla popolazione solo quelle migliori, e su queste applica due ulteriori funzioni: crossover e mutation;
fatto ciò, si otterrà una nuova popolazione su cui viene reiterato l'algoritmo, finchè nella fase di valutazione non viene trovata una soluzione accettabile.
