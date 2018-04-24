#include <stdio.h>

float min(float a, float b, float c, float d, float e) {
    float min = a;
    if (b < min) min = b;
    if (c < min) min = c;
    if (d < min) min = d;
    if (e < min) min = e;
    return min;
}
float max(float a, float b, float c, float d, float e) {
    float max = a;
    if (b > max) max = b;
    if (c > max) max = c;
    if (d > max) max = d;
    if (e > max) max = e;
    return max;
}

int main() {
    float a, b, c, d, e;
    
    printf("Enter five floating-point numbers:\n");
    scanf("%f%f%f%f%f", &a, &b, &c, &d, &e);

    printf("Sum is %.4f\n", a + b + c + d + e);
    printf("Min is %.4f\n", min(a, b, c, d, e));
    printf("Max is %.4f\n", max(a, b, c, d, e));
    printf("Product is %.4f\n", a * b * c * d * e);

    return 0;
}
