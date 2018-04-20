#include <stdio.h>

const int N = 50;

void mergesort(int s, int t, int * w, int * r);

int main()
{
    int working_space[N];
    int result[N];

    int n;
    scanf("%d", &n);

    for (int i = 0; i < n; i++)
    {
        scanf("%d", &result[i]);
    }

    mergesort(0, n, working_space, result);

    for (int i = 0; i < n; i++)
    {
        printf("%d\n", result[i]);
    }
}

void mergesort(int s, int t, int * w, int * r)
{
    if (t - s < 2)
        return;

    int m = (s + t) / 2;
    mergesort(s, m, w, r);
    mergesort(m, t, w, r);

    int pi = s;
    int pj = m;
    int pw = s;

    while (pi < m && pj < t)
    {
        if (r[pi] < r[pj])
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
