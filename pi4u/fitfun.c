#include <math.h>
#include "../common/waitFunction.hpp"

double fitfun(double /*const*/ *x, int N, void *output, int *info)
{
   int sampleId = info[3];
   double result = waitFunction(sampleId);
   return result;
}

