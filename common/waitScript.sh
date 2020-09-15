#!/bin/sh

meanTime=1.0
imbalanceRatio=0.9

spreadSize=`echo "(1.0 / (1.0 - $imbalanceRatio)) * $meanTime" | bc -l`
echo "SpreadSize: $spreadSize"
spreadRND=$(( $RANDOM % 100 ))
echo "SpreadRND: $spreadRND"
spreadMultiplier=`echo "($spreadRND/100)-0.5" | bc -l`
echo "SpreadMultiplier: $spreadMultiplier"
spread=`echo "$spreadMultiplier * $spreadSize" | bc -l`
echo "Spread: $spread"

waitTime=`echo "$meanTime + $spread" | bc -l`
>&2 echo "Waiting for $waitTime seconds..."
sleep $waitTime
