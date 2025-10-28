#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NUM_CHILDREN 5

// A simple busy-wait loop
void
cpu_work(int loops)
{
  volatile int x = 0;
  for (int i = 0; i < loops; i++) {
    x = (x + 1) % 100;
  }
}

int
main(int argc, char *argv[])
{
  printf("Starting MLFQ benchmark with %d children...\n", NUM_CHILDREN);

  for (int i = 0; i < NUM_CHILDREN; i++) {
    int pid = fork();
    if (pid < 0) {
      printf("fork failed\n");
      exit(1);
    }

    if (pid == 0) {
      // Child process
      int my_pid = getpid();
      
      // Variate behavior based on PID
      // Child 3 (low pid) will be I/O-bound (short work, long sleep)
      // Child 7 (high pid) will be CPU-bound (long work, short sleep)
      
      int work_loops = 1000000 * (my_pid + 1); // More work for higher PIDs
      int sleep_ticks = 20 / (my_pid + 1);    // Less sleep for higher PIDs
      if (sleep_ticks == 0) sleep_ticks = 1;

      printf("Child %d started (Work: %d loops, Sleep: %d ticks)\n", my_pid, work_loops, sleep_ticks);

      for(int j = 0; j < 20; j++) { // Run for 20 cycles
        cpu_work(work_loops);
        sleep(sleep_ticks);
      }
      
      printf("Process %d finished\n", my_pid);
      exit(0);
    }
  }

  // Parent process waits for all children
  for (int i = 0; i < NUM_CHILDREN; i++) {
    wait(0);
  }

  printf("Benchmark finished.\n");
  exit(0);
}