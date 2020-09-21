#!/bin/bash -l
#SBATCH --job-name="bench0256"
#SBATCH --output=bench0256.%j.out
#SBATCH --time=01:00:00
#SBATCH --nodes=256
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu

minTime=2.0
imbalanceRatio=0.0
nNodes=$SLURM_NNODES
nRanksMaster=$(( $nNodes + 1 )) # Master/Slave type schedulers require a dedicated rank
nRanksPeer=$nNodes
nGens=5
dakotaGens=$(( $nGens -1 )) # Dakota starts numbering generations from 0, thus -1
nExperiments=10
popSize=$((nNodes * 4))

echo '----------------------------------------------'
echo 'Adjusting Wait Script'
echo '----------------------------------------------'

pushd ../common > /dev/null

cat waitScript.sh.base | sed \
    -e 's/MINTIME/'$minTime'/g' \
    -e 's/IMBALANCERATIO/'$imbalanceRatio'/g' > waitScript.sh

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing Korali (Multiple)'
echo '----------------------------------------------'

pushd ../korali > /dev/null

date
command="srun -N $nNodes -n $nRanksMaster ./run-cmaes -n $popSize -g $nGens -e $nExperiments"

echo "Running all $nExperiments experiments together..."
echo $command
$command 2>&1 | grep "Elapsed Time" | tail -n 1

date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing Korali (Sequential)'
echo '----------------------------------------------'

pushd ../korali > /dev/null

date
command="srun -N $nNodes -n $nRanksMaster ./run-cmaes -n $popSize -g $nGens -e 1"

echo "Running Experiment $i"
echo $command
for i in $(seq 1 $nExperiments); do
 $command 2>&1 | grep "Elapsed Time"
done

date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing PI4U'
echo '----------------------------------------------'

pushd ../pi4u > /dev/null

cat cmaes_initials.par.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$nGens'/g' > cmaes_initials.par

date
command="srun -N $nNodes -n $nRanksPeer ./engine_cmaes_async"
echo "Running Experiment $i"
echo $command
for i in $(seq 1 $nExperiments); do
 $command 2>&1 | grep "elapsed"
done
date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing Dakota (Master)'
echo '----------------------------------------------'

pushd ../dakota > /dev/null

cat dakota.in.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$dakotaGens'/g' \
    -e 's/SCHEDULING/master/g' > dakota.in

date
command="srun -N $nNodes -n $nRanksMaster dakota --input dakota.in"
echo "Running Experiment $i"
echo $command
for i in $(seq 1 $nExperiments); do
 $command 2>&1 | grep "Total wall clock"
done
date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing Dakota (Peer - Static)'
echo '----------------------------------------------'

pushd ../dakota > /dev/null

cat dakota.in.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$dakotaGens'/g' \
    -e 's/SCHEDULING/peer static/g' > dakota.in

date
command="srun -N $nNodes -n $nRanksPeer dakota --input dakota.in"
echo "Running Experiment $i"
echo $command
for i in $(seq 1 $nExperiments); do
 $command 2>&1 | grep "Total wall clock"
done
date

popd > /dev/null


echo '----------------------------------------------'
echo 'Testing Dakota (Peer - Dynamic)'
echo '----------------------------------------------'

pushd ../dakota > /dev/null

cat dakota.in.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$dakotaGens'/g' \
    -e 's/SCHEDULING/peer dynamic/g' > dakota.in

date
command="srun -N $nNodes -n $nRanksPeer dakota --input dakota.in"
echo "Running Experiment $i"
echo $command
for i in $(seq 1 $nExperiments); do
 $command 2>&1 | grep "Total wall clock"
done
date

popd > /dev/null


