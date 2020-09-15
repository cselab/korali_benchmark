#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

double waitFunction(int sampleId)
{
  srand(sampleId); // seeding randomizer with sample id
  int base = 1000;
  int variance = 0;//rand()%500;
  int waitTime = (base + variance)*1000;

  printf("Waiting for: %d\n", waitTime);
  usleep(waitTime);
 
  return(waitTime);
}

