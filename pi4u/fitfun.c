#include <stdio.h>
#include <stdlib.h>
#include <string.h>

double fitfun(double /*const*/ *x, int N, void *output, int *info)
{
   int sampleId = info[0]*4096 + info[3];

   system("../common/waitScript.sh");

   // Generating random result
   srand(sampleId);
   return (double)rand() / 100000.0;
}

