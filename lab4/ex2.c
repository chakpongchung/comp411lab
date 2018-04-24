/* Example: bubble sort strings in array */

#include <stdio.h>  /* Need for standard I/O functions */
#include <string.h> /* Need for strlen() */


#define NUM 25   /* number of strings */
#define LEN 1000  /* max length of each string */

int main()
{
    char Strings[NUM][LEN];

    printf("Please enter %d strings, one per line:\n", NUM);

    for (int i = 0; i < NUM; i++) {
        fgets(Strings[i], LEN, stdin);
    }

    puts("\nHere are the strings in the order you entered:");

    /* Write a for loop here to print all the strings. */

    for (int i = 0; i < NUM; i++) {
        char *p = Strings[i];
        while (*p != '\0') {
            printf("%c", *p++);
        }
    }

    char temp[LEN];
    for (int i = NUM - 1; i > 0; i--) {
        int done = 1;
        /*
        for (int j = 0; j < i; j++) {
            if (strncmp(Strings[j], Strings[j + 1], strlen(Strings[j]) + 1) > 0) {
                // puts(Strings[j]);
                // puts(Strings[j + 1]);
                strncpy(Strings[j], temp, strlen(Strings[j]) + 1);
                strncpy(Strings[j + 1], Strings[j], strlen(Strings[j + 1]) + 1);
                strncpy(temp, Strings[j + 1], strlen(temp) + 1);
                done = 0;
            }
        }
        */
        for (int j = 0; j < i; j++) {
            if (strcmp(Strings[j], Strings[j + 1]) > 0) {
                // puts(Strings[j]);
                strcpy(temp, Strings[j]);
                strcpy(Strings[j], Strings[j + 1]);
                strcpy(Strings[j + 1], temp);
                done = 0;
            }
        }
        if (done == 1) break;
    }

    /* Output sorted list */

    puts("\nIn alphabetical order, the strings are:");

    for (int i = 0; i < NUM; i++) {
        char *p = Strings[i];
        while (*p != '\0') {
            printf("%c", *p++);
        }
    }

    return 0;
}
