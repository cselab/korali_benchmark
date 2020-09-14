#include <math.h>
#include <stdio.h>
#include <stdlib.h>

double fitfun(double /*const*/ *x, int N, void *output, int *info)
{
   srand(info[3]); // seeding randomizer with sample id
   int base = 1000;
   int variance = rand()%300;
   //printf("Random Number: %d\n", variance);
   usleep(base + variance);
   return variance;
}

