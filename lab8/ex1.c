#include <stdio.h>

char input[22];

int h_to_i(char * str);

int main() {
    int value;

    while (1) {
        fgets(input, 22, stdin);
        value = h_to_i(input);
        if (value == 0) {
            break;
        }
        printf("%d\n", value);
    }
}

int h_to_i(char * str) {
    int n = 0;
    for (int i = 0; input[i] != '\0' && input[i] != '\n'; i++) {
        n *= 16;
        if (input[i] >= '0' && input[i] <= '9') {
            n += input[i] - '0';
        } else {
            n += input[i] - 'a' + 10;
        }
    }
    return n;
}
