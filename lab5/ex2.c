#include <stdio.h>
#include <string.h>

void bedtimestory(char (*words)[15], int current, int number) {
    for (int i = 0; i < current; i++) {printf("  ");}

    if (current == number - 1) {
        printf("... who fell asleep.\n");
        return;
    }

    if (current == 0) {
        printf("A %s couldn't sleep, so her mother told a story about a little %s,\n",
                words[current], words[current + 1]);
    } else {
        printf("who couldn't sleep, so the %s's mother told a story about a little %s,\n",
                words[current], words[current + 1]);
    }

    bedtimestory(words, current + 1, number);

    for (int i = 0; i < current; i++) {printf("  ");}
    if (current == 0) {
        printf("... and then the %s fell asleep.\n", words[current]);
    } else {
        printf("... and then the little %s fell asleep;\n", words[current]);
    }
}

int main() {
    char names[20][15];
    int num = 0;

    while(1) {
        fgets(names[num], 13, stdin);
        names[num][strlen(names[num]) - 1] = '\0';
        if (strcmp(names[num], "END") == 0) {
            break;
        }
        num++;
    }

    bedtimestory(names, 0, num);
}

