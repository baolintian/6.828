#include <stdio.h>

int test(int x, int y, int z, int a, int b, int c, int d){
    int k = 5;
    //int test_space[10];
    return x+y+z+k+a+b+c+d;
}

int main(){
    int res = test(1, 2, 3, 4, 5, 6, 7);
    return 0;
}