#include <stdio.h>

int main() {
    int a;

    printf("Please enter a number from 1 to 5:\n");
    scanf("%d", &a);

    if (a > 5 || a < 0) {
        printf("Number is not in the range from 1 to 5");
    } else {
        for (int i = 0; i < a; i++) {
            printf("%d Hello World\n", i + 1);
        }
    }

    return 0;
}
    
