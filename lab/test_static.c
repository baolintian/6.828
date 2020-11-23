#include <stdio.h>

#define MMIO 4096

int test(){
    static int x = MMIO;
    x += 10;
    printf("%d\n", x);
}
int main(){

    test();
    test();
    return 0;
}