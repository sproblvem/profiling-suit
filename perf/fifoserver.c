#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <linux/stat.h>

#define PATHSIZE	1024
#define BUFLEN		0x40
char path[PATHSIZE];
char pid_path[PATHSIZE];
char perf_path[PATHSIZE];

int main(int argc, char *argv[])
{
	readlink("/proc/self/exe", path, PATHSIZE);
	*strrchr((const char *)path, '/') = 0;
	strcpy(pid_path, path);
	strcat(pid_path, "/PID-FIFO");
	strcpy(perf_path, path);
	strcat(perf_path, "/launch-perf.sh ");

    /* Our process ID and Session ID */
    pid_t pid, sid;
    
    /* Fork off the parent process */
    pid = fork();
    if (pid < 0) {
            exit(EXIT_FAILURE);
    }
    /* If we got a good PID, then
       we can exit the parent process. */
    if (pid > 0) {
            exit(EXIT_SUCCESS);
    }

    /* Close out the standard file descriptors */
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);
    
    FILE *fp;
    char readbuf[BUFLEN];
    char cmd[BUFLEN];

    /* Create the FIFO if it does not exist */
    umask(0);
    mknod(pid_path, S_IFIFO|0666, 0);

    while(1)
    {
            fp = fopen(pid_path, "r");
            fgets(readbuf, BUFLEN, fp);
			memset(cmd, 0, sizeof(cmd));
			strncpy(cmd, perf_path, BUFLEN);
			strncat(cmd, readbuf, BUFLEN);
			system(cmd);
            fclose(fp);
    }

    return(0);
}
