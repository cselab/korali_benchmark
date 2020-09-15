#include <stdio.h>
#include "../common/waitFunction.hpp"

int main(int argc, char* argv[])
{
  int sampleId = atoi(argv[1]);
 
  double waitTime = waitFunction(sampleId);

  printf("%f\n", waitTime);
  return 0;
}

