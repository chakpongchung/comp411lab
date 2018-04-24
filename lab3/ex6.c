#include <stdio.h>

int NchooseK(int n, int k);

int main() {
    int n, k;
    while (1) {
        puts("Enter two integers (for n and k) separated by space:");
        scanf("%d%d", &n, &k);
        if (n == 0 && k == 0) {
            puts("1");
            break;
        } else {
            printf("%d\n", NchooseK(n, k));
        }
    }
    return 0;
}

int NchooseK(int n, int k) {
    if (k == 0) {
        return 1;
    } else if (n == k) {
        return 1;
    } else {
        return NchooseK(n - 1, k - 1) + NchooseK(n - 1, k);
    }
}
