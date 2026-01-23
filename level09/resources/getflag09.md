provided binary reads its first argument, add to each char its index and prints res.
we decided to substract index from each char in token file:
```
#include <stdio.h>

int main() {
    int c;
    int index = 0;

    // getchar reads one byte at a time from stdin
    while ((c = getchar()) != EOF) {
        // Subtract index from the character value
        // putchar casts the result to unsigned char (handling underflow automatically)
        putchar(c - index);
        
        index++;
    }
    
    // Print a newline at the very end
    putchar('\n');
    
    return 0;
}

```

non-printable characters we changed on its value-index 