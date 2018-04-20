#include <stdio.h>

void parse(int n);

int main()
{
    int n;

    do
    {
        scanf("%d", &n);
        parse(n);
    }
    while (n != 0);
}

void parse(int n)
{
    int b;
    for (int i = 15; i >= 0; i--)
    {
        b = (n >> i) & 1;
        printf("%d", b);
    }
    printf("\n");
}
