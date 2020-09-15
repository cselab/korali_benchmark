#include "korali.hpp"

void model(korali::Sample &k)
{
  srand(k["Sample Id"]); // seeding randomizer with sample id
  int base = 750;
  int variance = rand()%500;
  int waitTime = (base + variance)*1000;

  //printf("Random Number: %d\n", variance);
  usleep(waitTime);
 
  k["F(x)"] = variance; 
}

int main(int argc, char *argv[])
{
  auto k = korali::Engine();
  auto e = korali::Experiment();

  e["Problem"]["Type"] = "Optimization";
  e["Problem"]["Objective Function"] = &model;

  e["Solver"]["Type"] = "Optimizer/CMAES";
  e["Solver"]["Population Size"] = 256;
  e["Solver"]["Termination Criteria"]["Max Generations"] = 5;

  e["Variables"][0]["Name"] = "X";
  e["Variables"][0]["Lower Bound"] = -3.0;
  e["Variables"][0]["Upper Bound"] = +3.0;

  e["File Output"]["Enabled"] = false;
  
  k["Conduit"]["Type"] = "Distributed";
  k.run(e);

  return 0;
}
