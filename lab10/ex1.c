#include <stdio.h>

void do_task(int a, int b);
int NchooseK(int n, int k);
int Fibonacci(int i);
void print_it(int i);

int main()
{
    int a, b;

    // read values for registers $s0-$s7 here
    int s0, s1, s2, s3, s4, s5, s6, s7;
    printf("Enter initial values for registers $s0-$s7\n");
    scanf("%d%d%d%d%d%d%d%d", &s0, &s1, &s2, &s3, &s4, &s5, &s6, &s7);
    // the above is simply a placeholder for what to do in assembly


    while (1) {
        printf("Enter a and b:\n");
        scanf("%d", &a);
        if(a==0)
            break;
        scanf("%d", &b);
        do_task(a, b);
    }

    // print final values of registers $s0-$s7 here
    // they should be the same as the values read in at the top
    printf("Here are the final values of registers $s0-$s7\n");
    printf("%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n", s0, s1, s2, s3, s4, s5, s6, s7);
}

void do_task(int a, int b)
{
    int n, k, result;
    n = a + b;
    k = a;

    result = NchooseK(n, k);
    print_it(result);

    result = Fibonacci(b);
    print_it(result);
}

int NchooseK(int n, int k)
{
    if((k == 0) || (n == k))
        return 1;
    else
        return NchooseK(n-1, k-1) + NchooseK(n-1, k);
}

int Fibonacci(int i)
{
    if((i == 0) || (i == 1))
        return i;
    else
        return Fibonacci(i-1) + Fibonacci(i-2);
}

void print_it(int i)
{
    printf("%d\n", i);
}
