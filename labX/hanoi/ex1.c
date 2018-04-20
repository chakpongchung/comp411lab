#include <stdio.h>

void hanoi(int s, int d, int m, int n);

int main()
{
    int n;
    scanf("%d", &n);

    hanoi(1, 3, 2, n);
}

void hanoi(int s, int d, int m, int n)
{
    if (n == 1)
    {
        printf("Move disk %d from Peg %d to Peg %d\n", n, s, d);
        return;
    }
    hanoi(s, m, d, n - 1);
    printf("Move disk %d from Peg %d to Peg %d\n", n, s, d);
    hanoi(m, d, s, n - 1);
}
