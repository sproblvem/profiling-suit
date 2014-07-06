#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PATHSIZE 1024
char path[PATHSIZE];
const char *filename = "/PID-FIFO";

int main(int argc, char *argv[])
{
	readlink("/proc/self/exe", path, PATHSIZE);
	*strrchr((const char *)path, '/') = 0;
	strcat(path, filename);

    FILE *fp;

    if ( argc != 2 ) {
            printf("USAGE: fifoclient [string]\n");
            exit(1);
    }

    if((fp = fopen(path, "w")) == NULL) {
            perror("fopen");
            exit(1);
    }
	
    fputs(argv[1], fp);

    fclose(fp);
    return(0);
}
