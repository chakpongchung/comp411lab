#include <stdio.h>

// Return the power of two. If the number is not a power of 2,
// the function will return the higher side of the number and
// add a negative sign before the power count.
int power_2 (int a) {
    int p = 1;
    int count = 0;

    while (p < a) {
        p *= 2;
        count++;
    }

    if (p > a) {
        return -count;
    } else {
        return count;
    }
}

int main() {
    int a;
    
    printf("Number ?\n");
    scanf("%d", &a);

    while (a != 0) {
        if (power_2(a) >= 0) {
            printf("%d is a power of two (%d)\n", a, power_2(a));
        } else {
            printf("%d is not a power of two, between %d and %d\n",
                a, -power_2(a) - 1, -power_2(a));
        }

        printf("Number ?\n");
        scanf("%d", &a);
    }
    printf("Done\n");

    return 0;
}
