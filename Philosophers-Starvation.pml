
#define N 5
#define MAX_EAT 3

mtype = { THINKING, HUNGRY, EATING, SATISFIED };

bool  fork[N];
mtype philosophers[N];

//Who is eating now?
bool eating[N];

// Requests/releases  channels  
chan req     = [N] of { byte };
chan release = [N] of { byte };

chan grant[N] = [0] of { bit };   

//Butler
proctype Butler() {
    byte inside = 0;
    byte id;

    do
    :: (inside < N-1) ->
        req?id;

     
        if
        :: (id == 4) ->
            skip;      
        :: else ->
            inside++;
            assert(inside <= N-1);
            grant[id]!1;
        fi

    :: release?id ->
        inside--;
        assert(inside <= N-1)
    od
}

//Philosopher
proctype Philosopher(byte id) {
    byte eat_count = 0;
    byte left  = id;
    byte right = (id + 1) % N;
    bit dummy;

    philosophers[id] = THINKING;
    eating[id] = false;

//Philosopher Life cycle
    do
    :: eat_count < MAX_EAT ->
            // Thinking then HUNGRY 
        philosophers[id] = THINKING;
        philosophers[id] = HUNGRY;

        req!id;
        grant[id]?dummy;   

        // Take forks + enter eating atomically 

atomic {
    (fork[left] && fork[right]) ->
    fork[left]  = false;
    fork[right] = false;

    eating[id] = true;
    philosophers[id] = EATING;

    assert(!eating[(id+N-1)%N] && !eating[(id+1)%N]);
}

        progress:
        skip; /* progress label anchor */

        eat_count++;

        // Exit eating + release forks atomically  
        atomic {
            eating[id] = false;
            fork[left]  = true;
            fork[right] = true;
            philosophers[id] = THINKING;
        }

        release!id;

    :: else ->
        philosophers[id] = SATISFIED;
        break
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

    run Butler();

    i = 0;
    do
    :: i < N ->
        run Philosopher(i);
        i++
    :: else -> break
    od
}

// LTL – Termination 
ltl eventual_satisfaction_all {
    [] <> (philosophers[0] == SATISFIED) &&
    [] <> (philosophers[1] == SATISFIED) &&
    [] <> (philosophers[2] == SATISFIED) &&
    [] <> (philosophers[3] == SATISFIED) &&
    [] <> (philosophers[4] == SATISFIED)
}

// LTL – No Starvation 
ltl no_starvation_all {
    [] ((philosophers[0] == HUNGRY) -> <> (philosophers[0] == EATING)) &&
    [] ((philosophers[1] == HUNGRY) -> <> (philosophers[1] == EATING)) &&
    [] ((philosophers[2] == HUNGRY) -> <> (philosophers[2] == EATING)) &&
    [] ((philosophers[3] == HUNGRY) -> <> (philosophers[3] == EATING)) &&
    [] ((philosophers[4] == HUNGRY) -> <> (philosophers[4] == EATING))
}

