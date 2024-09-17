#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define COLUMNS 6
int check = 0;

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
}

void print_sieves(int n){
  bool array[n];
  int i;
  int j;
  for (i = 0; i < n; i++){
    if (i > 1){
      array[i] = true;
    }
    else{
      array[i] = false;
    }
  }
  for (i = 0; i < n; i++){
    if (array[i] == true && i * i < n){
      int k = 2;
      int j = i;
      while (j * k < n){
        array[j * k] = false;
        k++;
      }
    }
  }
  for (i = 0; i < n; i++){
    if (array[i] == true){
      print_number(i);
    }
  }
  printf("\n");
}

int main(int argc, char *argv[]){
    if(argc == 2)
    {
        print_sieves(atoi(argv[1]));
    }
  else
    printf("Please state an integer number.\n");
  return 0;
}