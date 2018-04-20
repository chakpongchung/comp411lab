#include <stdio.h>
#include <string.h>

// maximum dimension of the picture
const int MAX_L = 64;

// the nine pixels used for blurring
const int DX[9] = {-1, 0, 1, -1, 0, 1, -1, 0, 1};
const int DY[9] = {-1, -1, -1, 0, 0, 0, 1, 1, 1};

int validate(int j, int i, int x, int y);

int main()
{
    // the magic number of the picture
    char magic[4];

    int x; // the number of columns
    int y; // the number of rows
    int m; // max value of any pixel component

    // 2d array used for storing the image
    short picture[MAX_L][MAX_L];

    // 2d array used for storing the blurred image
    short blur[MAX_L][MAX_L];

    fgets(magic, 4, stdin);

    scanf("%d", &x);
    scanf("%d", &y);
    scanf("%d", &m);

    for (int i = 0; i < y; i++)
        for (int j = 0; j < x; j++)
        {
            scanf("%hi", &picture[y - i - 1][j]);
        }

    for (int i = 0; i < y; i++)
        for (int j = 0; j < x; j++)
        {
            if (!validate(j, i, x, y))
            {
                blur[j][i] = picture[j][i];
                continue;
            }

            int temp = 0; // use an integer to prevent overflow of an byte

            for (int d = 0; d < 9; d++)
                temp += picture[j + DX[d]][i + DY[d]];

            temp /= 9;

            blur[j][i] = (short) temp;
        }

    printf("%s", magic); // the string "magic" already includes '\n'!

    printf("%d\n", x);
    printf("%d\n", y);
    printf("%d\n", m);

    for (int i = 0; i < y; i++)
        for (int j = 0; j < x; j++)
        {
            printf("%hi\n", blur[j][i]);
        }

}

int validate(int j, int i, int x, int y)
{
    return (j-1 >= 0) && (i-1 >= 0) && (j+1 < x) && (i+1 < y);
}