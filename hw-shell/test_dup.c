#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>


int main(){
    int fd = dup(1);
    printf("%d\n", fd);
    write(1, "hello ", 6);
    write(fd, "world\n", 6);

    return 0;
}