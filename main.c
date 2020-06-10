/* main.c simple program to run assembler subroutines */

#include <stdio.h>
#include <string.h>

/* Prototypes (declarations without definitions) of the subroutines that
 * are defined in assembly language.  All parameters and return values
 * are 64-bit values, either of type long long int or pointers to
 * arrays or strings.  */


void square(double X);  // prints X and its square
void selectionSort(long long int B[], long long int count);  // sorts B
void quicksort(double A[], long long int low, long long int hi);  // sorts A
char* concat( char* a, char* b ); // concatenates a and b into newly allocated memory


/* Recursive factorial and Fibonacci are provided as examples.  Note that
 * only small values of N will work.  Also note that doing Fibonacci recursively
 * is very stupid.
 */
unsigned long long int recursiveFactorial( unsigned long long int N );
unsigned long long int recursiveFibonacci( unsigned long long int N );

int main(void) {

	square(2.5);

	printf("\nThe concatenation of '%s' and '%s' is '%s'\n",
			     "Hello", "World!", concat("Hello", "World!") );
	printf("Good Advice: %s\n", concat("Seize ", concat("the ", "day!")) );

	long long b[] = { 67, 87, 103, 21, 48, 12, 209, 18, 40, 53, 97, 17 };
	selectionSort(b, 12);
	printf("Values sorted by selectionSort:\n");
	for (int i = 0; i <= 11; i++)
		printf("     %lld\n", b[i]);


	double a[] = { 67, 87, 103, 21, 48, 12, 209, 18, 40, 53, 97, 17 };

	quicksort(a, 0, 11);
	printf("\nValues sorted by quicksort:\n");
	for (int i = 0; i <= 11; i++)
		printf("   %f\n", a[i]);

	unsigned long long int n,f;
	n = 5;
	f = recursiveFactorial(n);
	printf("\nFactorial of %lld is %lld\n", n, f);
	f = recursiveFibonacci(n);
	printf("Fibonacci of %lld is %lld\n", n, f);
	n = 10;
	f = recursiveFactorial(n);
	printf("\nFactorial of %lld is %lld\n", n, f);
	f = recursiveFibonacci(n);
	printf("Fibonacci of %lld is %lld\n", n, f);

    return 0;
}
