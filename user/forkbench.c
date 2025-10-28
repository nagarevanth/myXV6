#include "kernel/types.h"
#include "user/user.h"

#define NUM_FORKS 1000   // Reduce if system slows down
#define WORKLOAD  50000 // Per-child computation size

void compute_workload() {
    int sum = 0;
    for (int i = 0; i < WORKLOAD; i++) {
        sum += (i * i) % 97;  // Arbitrary arithmetic
    }
}

void io_workload(int child_id) {
    if (child_id % 50 == 0) {  // Occasionally print
        printf("Child %d finished workload.\n", child_id);
    }
}

int main(int argc, char *argv[]) {
    int start_ticks, end_ticks;
    int pid;

    start_ticks = uptime();

    for (int i = 0; i < NUM_FORKS; i++) {
        pid = fork();
        if (pid < 0) {
            printf("Fork failed at iteration %d\n", i);
            exit(1);
        } 
        else if (pid == 0) {
            // Child: perform both CPU + simulated I/O
            compute_workload();
            io_workload(i);
            exit(0);
        } 
        else {
            wait(0);
        }
    }

    end_ticks = uptime();
    int total_ticks = end_ticks - start_ticks;

    printf("\n--- Realistic Fork Benchmark Results ---\n");
    printf("Total forks: %d\n", NUM_FORKS);
    printf("Total time in ticks: %d\n", total_ticks);
    printf("Average time per fork: %d ticks\n", total_ticks / NUM_FORKS);
    exit(0);
}
