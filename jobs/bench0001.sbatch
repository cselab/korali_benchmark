#!/bin/bash -l
#SBATCH --job-name="bench0001"
#SBATCH --output=bench0001.%j.out
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu

minTime=0.5
imbalanceRatio=0.0
nNodes=1
nGens=5
nExperiments=5
popSize=64

echo '----------------------------------------------'
echo 'Adjusting Wait Script'
echo '----------------------------------------------'

pushd ../common > /dev/null

cat waitScript.sh.base | sed \
    -e 's/MINTIME/'$minTime'/g' \
    -e 's/IMBALANCERATIO/'$imbalanceRatio'/g' > waitScript.sh

chmod a+x waitScript.sh

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing Korali (Multiple)'
echo '----------------------------------------------'

pushd ../korali > /dev/null

make clean > /dev/null ; make -j2 > /dev/null 2>&1

date
command="srun -N $nNodes -n 17 ./run-cmaes -n $popSize -g $nGens -e $nExperiments"

echo "Running all $nExperiments experiments together..."
echo $command
$command 2>&1 | tail -n 5

date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing Korali (Sequential)'
echo '----------------------------------------------'

pushd ../korali > /dev/null

make clean > /dev/null ; make -j2 > /dev/null 2>&1

date
command="srun -N $nNodes -n 17 ./run-cmaes -n $popSize -g $nGens -e 1"

for i in $(seq 1 $nExperiments); do
 echo "Running Experiment $i"
 echo $command
 $command 2>&1 | tail -n 5
done

date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing PI4U (With Job Stealing)'
echo '----------------------------------------------'

pushd ../pi4u > /dev/null

make clean > /dev/null ; make -j2 > /dev/null 2>&1

cat cmaes_initials.par.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$nGens'/g' > cmaes_initials.par

date
command="srun -N $nNodes -n 16 ./engine_cmaes"
for i in $(seq 1 $nExperiments); do
 echo "Running Experiment $i"
 echo $command
 $command 2>&1 | tail -n 7
done
date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing PI4U (Witout Job Stealing)'
echo '----------------------------------------------'

pushd ../pi4u > /dev/null

make clean > /dev/null ; make -j2 > /dev/null 2>&1

cat cmaes_initials.par.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$nGens'/g' > cmaes_initials.par

date
command="srun -N $nNodes -n 16 ./engine_cmaes_async"
for i in $(seq 1 $nExperiments); do
 echo "Running Experiment $i"
 echo $command
 $command 2>&1 | tail -n 7
done
date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing Dakota (Master)'
echo '----------------------------------------------'

pushd ../dakota > /dev/null

dakotaGens=$(( $nGens -1 )) # Dakota starts numbering generations from 0, thus -1

cat dakota.in.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$dakotaGens'/g' \
    -e 's/SCHEDULING/master/g' > dakota.in

date
command="srun -N $nNodes -n 17 dakota --input dakota.in"
for i in $(seq 1 $nExperiments); do
 echo "Running Experiment $i"
 echo $command
 $command 2>&1 | tail -n 2
done
date

popd > /dev/null

echo '----------------------------------------------'
echo 'Testing Dakota (Peer - Static)'
echo '----------------------------------------------'

pushd ../dakota > /dev/null

dakotaGens=$(( $nGens -1 )) # Dakota starts numbering generations from 0, thus -1

cat dakota.in.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$dakotaGens'/g' \
    -e 's/SCHEDULING/peer static/g' > dakota.in

date
command="srun -N $nNodes -n 16 dakota --input dakota.in"
for i in $(seq 1 $nExperiments); do
 echo "Running Experiment $i"
 echo $command
 $command 2>&1 | tail -n 2
done
date

popd > /dev/null


echo '----------------------------------------------'
echo 'Testing Dakota (Peer - Dynamic)'
echo '----------------------------------------------'

pushd ../dakota > /dev/null

dakotaGens=$(( $nGens -1 )) # Dakota starts numbering generations from 0, thus -1

cat dakota.in.base | sed \
    -e 's/POPULATION_SIZE/'$popSize'/g' \
    -e 's/NUM_GENERATIONS/'$dakotaGens'/g' \
    -e 's/SCHEDULING/peer dynamic/g' > dakota.in

date
command="srun -N $nNodes -n 16 dakota --input dakota.in"
for i in $(seq 1 $nExperiments); do
 echo "Running Experiment $i"
 echo $command
 $command 2>&1 | tail -n 2
done
date

popd > /dev/null


