/*
 print-primes.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6

int check = 0;

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

void print_number(int n){
  if (check < COLUMNS){
    printf("%10d ", n);
    check++;
  }
  else {
       printf("\n");
       printf("%10d ", n);
       check = 1;
  }
  printf("\n");
}

void print_primes(int n){
    // Should print out all prime numbers less than 'n'
    // with the following formatting. Note that
    // the number of columns is stated in the define
    // COLUMNS
  int i;
  for (int i = 2; i < n; i++){
    if (is_prime(i) == 1){
      print_number(i);
    }
  }
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
    if(argc == 2)
    {
        print_primes(atoi(argv[1]));
    }
  else
    printf("Please state an integer number.\n");
  return 0;
}