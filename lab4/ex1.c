/* Example: bubble sort strings in array */

#include <stdio.h>  /* Need for standard I/O functions */
#include <string.h> /* Need for strlen() */


#define NUM 25   /* number of strings */
#define LEN 1000  /* max length of each string */

int compare(char *s1, char *s2) {
    do {
        if (*s1 < *s2) {
            return 0;
        } else if (*s1 > *s2) {
            return 1;
        }
        s1++;
        s2++;
    } while (*s1 != '\0');

    return 0;
}

void copy(char *src, char *dst) {
    do {
        *dst++ = *src++;
    } while (*src != '\0');
    *dst = *src;
}

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
        for (int j = 0; j < i; j++) {
            if (compare(Strings[j], Strings[j + 1]) == 1) {
                // puts(Strings[j]);
                // puts(Strings[j + 1]);
                copy(Strings[j], temp);
                copy(Strings[j + 1], Strings[j]);
                copy(temp, Strings[j + 1]);
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
