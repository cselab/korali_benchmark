#!/bin/bash

./clean.sh
srun -n 17 dakota -error /dev/null -no_input_echo --input dakota_master.in
./clean.sh
srun -n 16 dakota -error /dev/null -no_input_echo --input dakota_peer_static.in
./clean.sh
srun -n 16 dakota -error /dev/null -no_input_echo --input dakota_peer_dynamic.in
./clean.sh

