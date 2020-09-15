#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

double waitFunction(int sampleId)
{
  srand(sampleId); // seeding randomizer with sample id
  int base = 750;
  int variance = rand()%500;
  int waitTime = (base + variance)*1000;

  usleep(waitTime);
 
  return(waitTime);
}

