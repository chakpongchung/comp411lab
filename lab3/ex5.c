/* Example: bubble sort values in array */

/* The bubble sort works by comparing values in adjacent
array positions. If the value in the "lower" position is 
greater than that in the "higher" position, the two are 
swapped. Thus the largest value "bubbles up" to the "top" 
of the array. When there are no more values to be swapped, 
sorting is complete. */

#include <stdio.h>

#define VALS 10 /* The number of values to be sorted */

int main()
{
  int i, sorted, swaps = 0, iterations = 0;
  float x[VALS], temp;
  
  /* Input values: */
  
  printf("Enter %i floating point values:\n", VALS);
  for (i = 0; i < VALS; i++)
  { printf("#%i:\n", i + 1);
    scanf("%f", &x[i]);
  }
  
  /* Bubble sort: */
  
  do {
    for (i = 1, sorted = 1; i < VALS; i++)
    {
      if (x[i-1] > x[i])
      {
        sorted = 0;
        temp = x[i-1];
        x[i-1] = x[i];
        x[i] = temp;
        swaps++;
      }
    }
    iterations++;
  } while (!sorted);
  
  /* Output sorted values: */
  
  puts("\nIn ascending order, the values are:");     
  for (i = 0; i < VALS; i++)
    printf("%G\n", x[i]);
  printf("\n%i swaps and %i iterations were performed.\n", swaps, iterations);
}
