#include <stdio.h>

int is_prime(int a) {
    if (a == 1) {
        return 1;
    }
    for (int i = 2; i < a; i++) {
        if (a % i == 0) {
            return i;
        }
    }
    return 0;
}

int main() {
    int a;

    printf("Number ?\n");
    scanf("%d", &a);

    while (a != 0) {
        switch(is_prime(a)) {
            case 0:
                printf("%d is a prime\n", a);
                break;
            case 1:
                printf("1 is non-prime (special case)\n");
                break;
            default:
                printf("%d is non-prime, divisible by %d\n",
                    a, is_prime(a));
                break;
        }
        printf("Number ?\n");
        scanf("%d", &a);
    }

    printf("Done\n");

    return 0;
}
