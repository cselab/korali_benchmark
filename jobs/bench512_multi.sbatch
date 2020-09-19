#!/bin/bash -l
#SBATCH --job-name="bench512_multi"
#SBATCH --output=bench512_multi.%j.out
#SBATCH --time=00:30:00
#SBATCH --nodes=512
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu

minTime=1.0
imbalanceRatio=0.5
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

echo "Running all $nExperiments experiments together..."

#command="srun -N $nNodes -n $nRanksMaster ./run-cmaes -n $popSize -g $nGens -e 1"
#echo $command
#for i in $(seq 1 $nExperiments); do
# $command 2>&1 | grep "Elapsed Time" | tail -n 1
#done

#command="srun -N $nNodes -n $nRanksMaster ./run-cmaes -n $popSize -g $nGens -e 2"
#echo $command
#for i in $(seq 1 $nExperiments); do
# $command 2>&1 | grep "Elapsed Time" | tail -n 1
#done
#date

#command="srun -N $nNodes -n $nRanksMaster ./run-cmaes -n $popSize -g $nGens -e 3"
#echo $command
#for i in $(seq 1 $nExperiments); do
# $command 2>&1 | grep "Elapsed Time" | tail -n 1
#done

#command="srun -N $nNodes -n $nRanksMaster ./run-cmaes -n $popSize -g $nGens -e 4"
#echo $command
#for i in $(seq 1 $nExperiments); do
# $command 2>&1 | grep "Elapsed Time" | tail -n 1
#done

command="srun -N $nNodes -n $nRanksMaster ./run-cmaes -n $popSize -g $nGens -e 5"
echo $command
for i in $(seq 1 $nExperiments); do
 $command 2>&1 | grep "Elapsed Time" | tail -n 1
done

popd > /dev/null

