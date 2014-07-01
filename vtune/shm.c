/*
 * shm-client - client program to demonstrate shared memory.
 */
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <stdlib.h>

#define SHMSZ     16

int main(int argc, char *argv[])
{
    int shmid;
    key_t key;
    int *shm;
	
	if (argc < 2) {
		printf("shm check | update | [0 - 255]\n");
		exit(0);
	}

    key = 1024;

    if ((shmid = shmget(key, SHMSZ, IPC_CREAT | 0666)) < 0) {
        perror("shmget");
        exit(1);
    }

    if ((shm = shmat(shmid, NULL, 0)) == (int *) -1) {
        perror("shmat");
        exit(1);
    }
	
//	printf("shm : %d\n", *shm);
	if (strcmp(argv[1], "check") == 0)
		exit(*shm);
	
	if (strcmp(argv[1], "update") == 0)
		exit(++(*shm));

	*shm = atoi(argv[1]);
	exit(*shm);
}
