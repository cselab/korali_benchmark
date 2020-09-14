#include <math.h>
#include <stdio.h>
#include <stdlib.h>

double fitfun(double /*const*/ *x, int N, void *output, int *info)
{
   srand(info[3]); // seeding randomizer with sample id
   int base = 750;
   int variance = rand()%500;
   int waitTime = (base + variance)*1000;
   //printf("Random Number: %d\n", variance);
   usleep(waitTime);
   return variance;
}

