#define N 5
#define MAX_EAT 3

mtype = { THINKING, HUNGRY, EATING, SATISFIED };

bool  fork[N];
mtype philosophers[N];

//Who is eating now?
bool eating[N];

// Requests/releases  channels  

//Butler

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


        // Take forks + enter eating atomically 

atomic {


        fork[left]  -> fork[left]  = false;
        skip; 
        fork[right] -> fork[right] = false;

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


    i = 0;
    do
    :: i < N ->
        run Philosopher(i);
        i++
    :: else -> break
    od
}
