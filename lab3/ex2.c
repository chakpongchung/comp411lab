/* Example: analysis of text */

#include <stdio.h>
#include <string.h>

#define MAX 1000 /* The maximum number of characters in a line of input */

int main()
{
  char text[MAX],text2[MAX], c;
  int i;
  int lowercase, uppercase, digits, other;
  int length;
  
  puts("Type some text (then ENTER):");
  
  /* Save typed characters in text[]: */
    
  fgets(text, MAX, stdin);
  length = strlen(text) - 1;

  int palindrome;
  palindrome = 1;

  for (int i = 0; i < length; i++)
  {
    text2[length - i - 1] = text[i];
    if (text[i] != text[length - i - 1])
    {
      palindrome = 0;
    }
  }

  puts("Your input in reverse is:");
  puts(text2);

  if (palindrome)
  {
    puts("Found a palindrome!");
  }
}
