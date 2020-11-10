//来源：公众号【编程珠玑】
#include <stdio.h>
/*要使用变长参数的宏，需要包含下面的头文件*/
#include <stdarg.h>
/*
 * getSum：用于计算一组整数的和
 * num：整数的数量
 *
 * */
int getSum(int num,...)
{
    va_list ap;//定义参数列表变量
    int sum = 0;
    int loop = 0;
    va_start(ap,num);
    /*遍历参数值*/
    for(;loop < num ; loop++)
    {
        /*取出并加上下一个参数值*/
        sum += va_arg(ap,int);
    }
    va_end(ap);
    return sum;
}
int main(int argc,char *argv[])
{
    int sum = 0;
    sum = getSum(6,1,2,3,4,5, 6);
    printf("%d\n",sum);
    return 0;
}