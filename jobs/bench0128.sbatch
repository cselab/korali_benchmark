#!/bin/bash -l
#SBATCH --job-name="bench0128"
#SBATCH --output=bench0128.%j.out
#SBATCH --time=00:30:00
#SBATCH --nodes=128
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu

cd ..

date
mir.run --runargs "-n 129 --ntasks-per-node=1" ./run-cmaes.py 128
date
