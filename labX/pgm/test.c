#include <stdio.h>

int main()
{
    int k[2][5];

    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 2; j++)
        {
            k[j][i] = j + i * 2;
        }

    int * pk = &k[0][0];

    for (int i = 0; i < 10; i++)
    {
        printf("%d\n", *pk++);
    }
}