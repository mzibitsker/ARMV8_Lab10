// @author Maxim Zibitsker

	.globl quicksort
	.globl recursiveFactorial
	.globl recursiveFibonacci
	.globl selectionSort
	.globl square
	.globl concat
	.extern printf
	.extern malloc
	.extern strlen
	.extern strcpy
	
	

// square(x) prints x and its square

square:
   // MOV X20, X30     // Save return address in X20

    sub sp, sp, #16         // make room on stack
    stur x30, [sp,#8]       // save return address on stack
    stur x0,  [sp,#0]       // save N on stack


    FMUL D1, D0, D0  // Put square of D0 in D1
    LDR X0, =sqstr   // Address of string in X0
    BL printf        // Call printf


    //MOV X30, X20     // Restore return address to X30


    ldur x1, [sp,#0]        // retrieve N from stack into x1
    ldur x30, [sp,#8]       // retrieve return address
    add sp,sp,#16           // restore original value of stack pointer!
    RET

sqstr: .asciz "The square of %f is %f\n"
     .balign 4



// void selectionSort( long long int B[] )  sorts the array B
// This function will call the maxLoc() function, defined below!

selectionSort:
	// long long int - X0 - B[]
	// long long int - X1 - Counter


    sub sp, sp, #32         // make room on stack - 4 bytes
    stur x30, [sp,#8]       // save return address on stack
    stur x0,  [sp,#0]       // save N on stack
	stur x1, [sp, #16]
	// save x0 on stack
	// save x1 on stack
	loop_SS:
		CMP x1,#0
		B.LE done_SS
		// else proceed to loop

		// long long int loc = maxloc(B, count)
		// feed X0, X1 into maxloc
		BL maxLoc
		// output is the maxlocation in the array

		// long long int loc = store index of largest into x2
		MOV X2, X0
		// restore the values back
	ldur x0, [sp,#0]
    ldur x1, [sp,#16]        // retrieve N from stack into x1



		// decrement count

		// subtract 1 from x1,
		SUB x1, x1, #1
		// save new value of count onto the stack
		stur x1, [sp, #16]
		// long long int temp1 = B[count] // swap B[count] and B[loc]
		ldr X4, [x0, x1, lsl #3]
		//long long int temp2 = B[loc]
		ldr X5, [x0, x2, lsl #3]

		// B[count] = temp2
		str x4,[x0,x2,lsl #3]

		// B[loc] = temp1
		str x5,[x0,x1,lsl #3]

		// Branch back to loop
		B loop_SS



	// end of subroutine
	done_SS:
	ldur x30, [sp,#8]       // retrieve return address
    add sp,sp,#32           // restore original value of stack pointer!

       // stub function just returns B without sorting
    ret



// void quicksort(double A[], long long int low, long long int hi);
// This function will call the quicksortStep() function, defined below!

quicksort:


    sub sp, sp, #64         // make room on stack - 8 bytes
    stur x30, [sp,#8]       // save return address on stack
    stur x0,  [sp,#0]       // save double[] A on stack
	stur x1, [sp, #16] // lo
	stur x2, [sp, #24] // hi

			// double[] A, long long int low, long long int high
	     //if ( low >= high) {
	     CMP x1, x2
	     B.LT else_QS
	     B.GE done_QS
	        // return;

     //else {
     else_QS:
         //long long int mid = quicksortStep( A, low, high );



		// feed D0, X1, X2 into quicksortStep
		BL quicksortStep
		// output is in x0

		MOV x3, x0


		// restore the values back


    ldr x0,  [sp,#0]       // save double[] A on stack
	ldr x1, [sp, #16] // lo
	ldr x2, [sp, #24] // hi
	// store x3 on the stack
	str x3, [sp, #32]



    // retrieve N from stack into x1
         //quicksort( A, low, mid - 1 );
         // uses original array,
         // compute mid -1, and place into the x2 register
         SUB x2, x3, #1
         BL quicksort

// restore the values back
	ldr x0,  [sp,#0]       // save double[] A on stack
	ldr x1, [sp, #16] // lo
	ldr x2, [sp, #24] // hi
	ldr x3, [sp, #32]

        // A is in x0, mid + 1 needs to be computed, high is in x2
        //quicksort(A, mid + 1, high )
      	// compute mid +1, and place into the x1 register
      	ADD x1, x3, #1
      	// Call quicksort
      	BL quicksort
		// Branch to end of program
      	B done_QS



        // stub function just returns A without sorting

   done_QS:
   ldur x30, [sp,#8]       // retrieve return address
    add sp,sp,#64           // restore original value of stack pointer!

    ret




// char* concat( char* a, char* b )  concatenates two strings
// This function will use standard functions malloc, strlen, and strcpy.

concat:

	sub sp, sp, #64         // make room on stack - 4 bytes
    stur x30, [sp,#8]       // save return address on stack
    stur x0,  [sp,#0]       // save char* a
	stur x1, [sp, #16] //  save char* b

 	//long long int aLength = strlen(a);
 	BL strlen
 	MOV x3, x0
 	stur x3, [sp, #24]

 	// restore
    ldr x0,  [sp,#0]       // save char* a
	ldr x1, [sp, #16] //  save char* b
	ldr x3, [sp, #24]
    //long long int bLength = strlen(b);
    BL strlen
    MOV x4, x0
    stur x4, [sp, #32]

    // restore
    ldr x0,  [sp,#0]       // save char* a
	ldr x1, [sp, #16] //  save char* b
	ldr x3, [sp, #24]
	ldr x4, [sp, #32]
    //long long int cLength = aLength + bLength + 1;
     ADD x5, x3, x4
     // add 1
     ADD x5, x5, #1

     // store x5 onto the stack
     str x5, [sp, #40]


    // MOV cLength into X
    MOV X0, x5

    //char* newString = malloc( cLength );
	BL malloc
	 //output is in x0
	 MOV x23, x0
	 MOV x24, x0



	ldr x0,  [sp,#0]       // save char* a
	ldr x1, [sp, #16] //  save char* b
// restore the return address
	ldr x30, [sp, #8]
    //strcpy(newString, a);
   // store newString in x23
   	str x23, [sp, #48]

	// a is in x0
	// newString is in x23
   	MOV x1, x0
    MOV x0, x23
	// strcpy(newString, a)
    BL strcpy

    // store output in register x25 and on stack

    MOV X25, X0
    // next


    ldr x0,  [sp,#0]       // save char* a
	ldr x1, [sp, #16] //  save char* b
// restore the return address
	ldr x30, [sp, #8]
	ldr x3, [sp, #24]
	ldr x23, [sp, #48]



    //char* bPosition = newString + aLength;  // Adds aLength to the address.
	ADD x7, x23, x3

    //strcpy(bPosition, b);

    //move x7 into x0
    // load original x1 into subroutine
    MOV x0, x7
    BL strcpy
    MOV x26, x0

    B done_CC


    done_CC:


	//retore x30 and SP
	// load new string into x0 from memory address bPosition (i.e. x7)
	//ldr x0, [x0, x7, lsl #3]
	ldr x23, [sp, #48]
	MOV x0, x23
	ldr x30, [sp, #8]
    //return newString;


    add sp,sp,#64           // restore original value of stack pointer!


      // stub fucntion just returns a
	ret


// --------------------  Nothing below this line needs to be changed --------------------

// long long int maxLoc(long long int B[], count)
// returns the index of the largest element among B[0], B[1], ..., B[count-1]
// precondition:  count >= 1

maxLoc:
    mov x2, #0              // index into array starts at zero
    ldr x3, [x0,x2,lsl #3]  // x3 = B[index], largest item seen so far
    mov x4, #0              // location of largest item seen
maxLocLoop:
    add x2, x2, #1          // index = index + 1
    cmp x2,x1               // if index is equal to count
    b.eq maxLocDone         //     then we are done
    ldr x5, [x0,x2,lsl #3]  // x5 = B[index]
    cmp x5, x3              // if x5 < largest item seen so far,
    b.lt maxLocLoop         //    go onto next index
    mov x3, x5              // x5 is now the largest item seen
    mov x4, x2              // and its index is x2
    b maxLocLoop
maxLocDone:
    mov x0, x4
    ret



// long long int quicksortStep(double A[], long long int low, long long int hi);
// precondition:  hi >= low

quicksortStep:
    ldr D0, [X0, x1, LSL #3]    // D0 is temp
qqsLoop:
    cmp X1, X2     // when hi == low, we are finished
    b.eq qqsDone
	ldr D1, [X0, X2, LSL #3]  // D1 is A[hi]
	fcmp D1,D0
	b.lt qqsMove1
	sub X2, X2, #1  // hi--
	b qqsLoop
qqsMove1:
    str D1, [X0, X1, LSL #3]  // A[low] = D1
    add X1, X1, #1   // low++
qqsLoop2:
    cmp X1, X2
    b.eq qqsDone
    ldr D1, [X0, X1, LSL #3]   // D1 = A[low[
    fcmp D1, D0
    b.gt qqsMove2
    add x1, x1, #1  // low++
    b qqsLoop2
qqsMove2:
    str D1, [X0, X2, LSL #3]  // A[hi] = D1
    sub X2, X2, #1   // hi--
    b qqsLoop
qqsDone:
	str D0, [x0, x1, LSL #3]
	mov X0, X1
    ret


// unsigned long long int recursiveFactorial(unsigned  long long int N) {

recursiveFactorial:
    cmp x0, #1     // if N > 1
    B.HI fact1     //    do the recursion
    mov x0, #1     // otherwise, return value is 1
    ret
fact1:
    sub sp, sp, #16         // make room on stack
    stur x30, [sp,#8]       // save return address on stack
    stur x0,  [sp,#0]       // save N on stack
    sub x0, x0,#1           // x0 = N - 1
    bl recursiveFactorial   // call function recusively on N-1
    ldur x1, [sp,#0]        // retrieve N from stack into x1
    ldur x30, [sp,#8]       // retrieve return address
    add sp,sp,#16
    sub sp, sp, #16         // make room on stack
    stur x30, [sp,#8]       // save return address on stack
    stur x0,  [sp,#0]       // save N on stack6           // restore original value of stack pointer!
    mul x0,x0,x1            // return factorial(N-1) * N
    ret



// unsigned long long int recursiveFibonacci  long long int N) {

recursiveFibonacci:
    cmp x0, #2              // if N > 2
    B.HS fib1               //    evaluate the function recursively
    ret                     // for N = 1 or 0, just return N
fib1:
    sub sp, sp, #32         // Make room on stack for N, a, return value; sp must be multiple of 16!
    stur x30, [sp,#24]      // save return address on stack
    stur x0, [sp,#16]       // save N on stack
    sub x0, x0, #2
    bl recursiveFibonacci   // call function recursively on N-2
    stur x0, [sp,#8]        // save a on stack
    ldur x0, [sp,#16]       // retrieve N from the stack
    sub x0, x0, #1
    bl recursiveFibonacci   // call function recursive on N-1
    ldur x30, [sp,#24]      // retrieve return address from the stack
    ldur x1, [sp,#8]        // retrieve a from the stack into x1
    add sp, sp, #32
    add x0, x0, x1          // x0 now contains a+b
    ret


