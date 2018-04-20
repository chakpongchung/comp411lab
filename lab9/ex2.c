#include <stdio.h>

int main()
{
    int seed, random_number, b;
    scanf("%d", &seed);

    random_number = seed;

    do
    {
        printf("%d\n", random_number);
        b = ((random_number >> 4) & 1) ^ ((random_number >> 2) & 1);
        random_number = ((random_number << 1) & 31) | b;
    }
    while (random_number != seed);
}
