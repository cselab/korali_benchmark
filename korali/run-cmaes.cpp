#include "korali.hpp"

void model(korali::Sample &k)
{
  system("../common/waitScript.sh");

  srand(k["Sample Id"]); // seeding randomizer with sample id
  k["F(x)"] = (double)rand() / 100000.0;
}

int main(int argc, char *argv[])
{
 int n  = 1; // Number of samples per generation
 int g  = 1; // Number of generations
 int nE = 1; // Number of experiments

  for (int i = 1; i < argc; i++)
  {
   bool recognized = false;

   if(!strcmp(argv[i], "-g")) { g = atoi(argv[++i]); recognized = true; }
   if(!strcmp(argv[i], "-n")) { n = atoi(argv[++i]); recognized = true; }
   if(!strcmp(argv[i], "-e")) { nE = atoi(argv[++i]); recognized = true; }

   if (recognized == false)
   {
    fprintf(stderr, "[Error] Unrecognized parameter: %s\n", argv[i]);
    exit(-1);
   }
  }
  
  std::vector<korali::Experiment> eList(nE);
  auto k = korali::Engine();

  for(size_t i = 0; i < nE; i++)
  {

   eList[i]["Problem"]["Type"] = "Optimization";
   eList[i]["Problem"]["Objective Function"] = &model;

   eList[i]["Solver"]["Type"] = "Optimizer/CMAES";
   eList[i]["Solver"]["Population Size"] = n;
   eList[i]["Solver"]["Termination Criteria"]["Max Generations"] = g;

   eList[i]["Variables"][0]["Name"] = "X";
   eList[i]["Variables"][0]["Lower Bound"] = -3.0;
   eList[i]["Variables"][0]["Upper Bound"] = +3.0;

   eList[i]["File Output"]["Enabled"] = false;
  }  

  k["Conduit"]["Type"] = "Distributed";
  k.run(eList);

  return 0;
}
