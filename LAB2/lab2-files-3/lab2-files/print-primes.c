/*
 print-primes.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6

int is_prime(int n){
  int checker = 1;
  int i = 2;
  while (i < n - 1){
    if (n % i == 0){
      checker = 0;
      break;
    }
    i++;
  }
  return checker;
}

void print_numbers(int n){  
  int checker = 0;
  for (int i = 1; i < n; i++){
    if (is_prime(i) == 1){
      if (checker < COLUMNS){
        printf("%10d ", i);
        checker++;
      }
      else{
        printf("\n");
        printf("%10d ", i);
        checker = 1;
      }
    }
  }
  printf("\n");
}

void print_primes(int n){
    // Should print out all prime numbers less than 'n'
    // with the following formatting. Note that
    // the number of columns is stated in the define
    // COLUMNS
    
    printf("%10d ", n);
    printf("%10d ", n);
    printf("%10d ", n);
    printf("%10d ", n);
    printf("%10d ", n);
    printf("%10d ", n);
    printf("\n");
    printf("%10d ", n);
    printf("%10d ", n);
    printf("\n");
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
    if(argc == 2)
    {
        print_numbers(atoi(argv[1]));
    }
  else
    printf("Please state an integer number.\n");
  return 0;
}