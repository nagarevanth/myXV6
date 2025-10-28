#include "kernel/types.h"
#include "user/user.h"

void print_sysmem(char *label) {
    struct sysinfo info;
    sysinfo(&info);
    printf("%s:\n", label);
    printf("  Total: %d KB\n", (int)(info.total / 1024));
    printf("  Used : %d KB\n", (int)(info.used / 1024));
    printf("  Free : %d KB\n", (int)(info.free / 1024));
}


// this is revanth's code for quantifing the use of CoW

int main(int argc, char *argv[]) {
    print_sysmem("Before allocation");

    char *buf = sbrk(16 * 1024 * 1024);  // allocate 16MB
    for (int i = 0; i < 16 * 1024 * 1024; i += 4096)
        buf[i] = 0;

    print_sysmem("After allocation");

    int pid = fork();
    if (pid == 0) {
        // Child process
        buf[0] = 42; // maybe write to trigger COW
        print_sysmem("Child after write");
        exit(0);
    } else {
        wait(0);
    }

    print_sysmem("Parent after fork");
    exit(0);
}
