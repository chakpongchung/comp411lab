#include <stdio.h>

// Move 'n' disks from 's' to 't', using 'm' as medium.
void hanoi(int s, int t, int m, int n);

int main()
{
    int n;
    scanf("%d", &n);

    hanoi(1, 3, 2, n);
}

void hanoi(int s, int t, int m, int n)
{
    if (n == 1)
    {
        printf("Move disk %d from Peg %d to Peg %d\n", n, s, t);
        return;
    }
    hanoi(s, m, t, n - 1);
    printf("Move disk %d from Peg %d to Peg %d\n", n, s, t);
    hanoi(m, t, s, n - 1);
}
