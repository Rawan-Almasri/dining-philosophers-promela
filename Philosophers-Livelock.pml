
#define N 5
#define MAX_EAT 3

mtype = { THINKING, HUNGRY, EATING, SATISFIED };

bool  fork[N];
mtype philosophers[N];

//Who is eating now?
bool eating[N];

// Requests/releases  channels  

//Philosopher
proctype Philosopher(byte id) {
    byte left  = id;
    byte right = (id + 1) % N;

    philosophers[id] = THINKING;
    eating[id] = false;

    do
    :: true ->
        philosophers[id] = HUNGRY;

        /* try take LEFT */
        if
        :: fork[left] ->
            atomic { fork[left] = false; }

            /* try take RIGHT */
            if
            :: fork[right] ->
                /* If we ever get here, we eat (but livelock may avoid this forever) */
                atomic {
                    fork[right] = false;
                    eating[id] = true;
                    philosophers[id] = EATING;

                    /* safety: neighbors not eating */
                    assert(!eating[(id+N-1)%N] && !eating[(id+1)%N]);
                }

                /* progress anchor: if livelock exists, SPIN finds a cycle that never reaches here */
                progress:
                skip;

                atomic {
                    eating[id] = false;
                    fork[left]  = true;
                    fork[right] = true;
                    philosophers[id] = THINKING;
                }

            :: else ->
                /* polite backoff: failed to get RIGHT -> release LEFT immediately */
                atomic { fork[left] = true; }
                philosophers[id] = THINKING;
            fi

        :: else ->
            /* can't get LEFT, keep trying (still “moving”) */
            skip
        fi
    od
}


init {
    byte i;

    i = 0;
    do
    :: i < N ->
        fork[i] = true;
        philosophers[i] = THINKING;
        eating[i] = false;
        i++
    :: else -> break
    od;


    i = 0;
    do
    :: i < N ->
        run Philosopher(i);
        i++
    :: else -> break
    od
}

// LTL – No Starvation 
ltl no_starvation_all {
    [] ((philosophers[0] == HUNGRY) -> <> (philosophers[0] == EATING)) &&
    [] ((philosophers[1] == HUNGRY) -> <> (philosophers[1] == EATING)) &&
    [] ((philosophers[2] == HUNGRY) -> <> (philosophers[2] == EATING)) &&
    [] ((philosophers[3] == HUNGRY) -> <> (philosophers[3] == EATING)) &&
    [] ((philosophers[4] == HUNGRY) -> <> (philosophers[4] == EATING))
}

