#include <stdio.h>

int *test[] = {
[1] = 1111111,
[2] = 2222222,

};
#define uint unsigned int
int x=233;
int main(){
    printf("%x %x %d, %d\n", test, &test, *(&test[0]), *(&test[1]));
    *(int *)x = test;
    //*(uint* )(x) = 3333333;
    //printf("%x\n", (x));
    return 0;
}