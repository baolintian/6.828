#include<cstdio>
using namespace std;
struct Test
{
    struct Test *nex;
    short x;
};
Test * temp1;

int main(){
    Test temp1;
    printf("233\n");
    printf("%d\n", sizeof(temp1));
    
    //printf("%d\n", (temp3[1])->a1);
    
    return 0;
}