/*
 *  Notes for this assignment:
 *
 *  Remember when reading integers along with strings,
 *    we need to use 'scanf' to remove the '\n' left 
 *    by each of the integer!
 *    
*/

#include <stdio.h>
#include <string.h>

typedef struct
{
    char name[20];
    int id;
} record;

void mergesort(int s, int t, record * w, record * r);
int less(record a, record b);

int main()
{
    record working_space[50];
    record result[50];
    int n;

    scanf("%d\n", &n);

    for (int i = 0; i < n; i++)
    {
        fgets(result[i].name, 20, stdin);
        scanf("%d\n", &result[i].id);
    }

    mergesort(0, n-1, working_space, result);

    for (int i = 0; i < n; i++)
    {
        printf("%s%d\n", result[i].name, result[i].id);
    }
}

void mergesort(int s, int t, record * w, record * r)
{
    if (t - s < 2)
        return;

    int m = (s + t) / 2;
    mergesort(s, m, w, r);
    mergesort(m, t, w, r);

    int pi = s;
    int pj = m;
    int pw = s;

    // printf("s = %d, m = %d, t = %d\n", s, m, t);
    while (pi < m && pj < t)
    {
        // printf("pi = %d, pj = %d, pw = %d\n", pi, pj, pw);
        // printf("r[pi]=%s%d\n, r[pj]=%s%d\n, less(pi, pj)=%d\n", 
        //     r[pi].name, r[pi].id, r[pj].name, r[pj].id, less(r[pi], r[pj]));
        if (less(r[pi], r[pj]))
        {
            w[pw++] = r[pi++];
        }
        else
        {
            w[pw++] = r[pj++];
        }
    }
    while (pi < m)
    {
        w[pw++] = r[pi++];
    }
    while (pj < t)
    {
        w[pw++] = r[pj++];
    }

    for (int i = s; i < t; i++)
    {
        r[i] = w[i];
    }
}

int less(record a, record b)
{
    return strcmp(a.name, b.name) < 0 || (strcmp(a.name, b.name) == 0 && a.id < b.id);
}