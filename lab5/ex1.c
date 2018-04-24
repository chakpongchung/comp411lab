#include<stdio.h>
#include<stdlib.h>

#define true 1
#define false 0

#define MAX 100

const int dx[4] = {-1, 0, 1, 0};
const int dy[4] = {0, -1, 0, 1};

int maze[100][100];             // 100x100 is the maximum size needed
int wasHere[100][100];
int correctPath[100][100];
int width, height;
int startX, startY, endX, endY;

int recursiveSolve(int x, int y);

int main() {

    int x, y;
    scanf("%d%d", &width, &height);
    scanf("\n");    // This is needed to "eat" the newline after height,
                    // before the actual maze entries begin on the next line


    /* NOTE:  maze[y][x] will refer to the (x,y) element of the maze,
  	   i.e., y-th row and x-th column in the maze.
       The row is typically the first index in a 2D array because
       reading and writing is done row-wise.  This is called
       "row-major" order.

       Also note that although we have declared the maze to be 100x100,
       that is the maximum size we need.  The actual entries in the
       maze will be height * width.
    */

    char tempchar;

    for(y=0; y < height; y++) {
        for(x=0; x < width; x++) {
            scanf("%c", &tempchar);
            maze[y][x]=tempchar;

            if (tempchar == 'S') {
                startX = x;
                startY = y;
            } else if (tempchar == 'F') {
                endX = x;
                endY = y;
            }

            wasHere[y][x] = false;
            correctPath[y][x] = false;
        }
        scanf("\n");    // This is used to "eat" the newline
    }
    
    if (recursiveSolve(startX, startY)) {
        correctPath[startY][startX] = false;
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                if (correctPath[i][j]) {
                    maze[i][j] = '.';
                }
                printf("%c", maze[i][j]);
            }
            printf("\n");
        }
    }
}


int recursiveSolve(int x, int y) {
    if (x < 0 || y < 0 || x >= width || y >= height) {
        return false;
    }
    if (wasHere[y][x] || maze[y][x] == '*') {
        return false;
    }

    if (endX == x && endY == y) {
        return true;
    }

    wasHere[y][x] = true;
    for (int i = 0; i < 4; i++) {
        if (recursiveSolve(x + dx[i], y + dy[i])) {
            correctPath[y][x] = true;
            return true;
        }
    }
    
    return false;
}
