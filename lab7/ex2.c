#include<stdio.h>

char magic[4];

int rgb_to_gray(int r, int g, int b, int ppm_max);
void iterate_through_pix(int rows, int cols, int ppm_max);

int x1, x2, y1, y2;

int main() {
    int rows, cols;
    int ppm_max;

    puts("P3");

    scanf("%d%d%d%d", &x1, &x2, &y1, &y2);

    scanf("%d%d", &cols, &rows);
    printf("%d\n%d\n", cols, rows);

    scanf("%d", &ppm_max);
    printf("%d\n", 255);

    iterate_through_pix(rows, cols, ppm_max);
}

void iterate_through_pix(int rows, int cols, int ppm_max) {
    int i, j, r, g, b;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            scanf("%d%d%d", &r, &g, &b);
            if (i < y1 || i > y2 || j < x1 || j > x2) {
                r = rgb_to_gray(r, g, b, ppm_max);
                g = r;
                b = r;
            }
            printf("%d\n%d\n%d\n", r, g, b);
        }
    }
}

int rgb_to_gray(int r, int g, int b, int ppm_max) {
    return ((r*30 + g*59 + b*11) * 255) / (100 * ppm_max);  // Follow exactly this ordering in assembly
}
