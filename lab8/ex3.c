#include <stdio.h>

int h_to_i(char * str);
int NchooseK(int n, int k);

char input[22];

int main() {
    int n, k, result;

    while(1) {
        fgets(input, 22, stdin);
        n = h_to_i(input);

        if (n == 0) break;

        fgets(input, 22, stdin);
        k = h_to_i(input);

        result = NchooseK(n, k);
        printf("%d\n", result);
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
int NchooseK(int n, int k) {
    if (k == n || k == 0) {
        return 1;
    }
    return NchooseK(n - 1, k - 1) + NchooseK(n - 1, k);
}
