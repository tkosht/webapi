#!/bin/sh
d=$(cd $(dirname $0) && pwd)
cd $d/../

url="https://archive.ics.uci.edu/ml/machine-learning-databases/00374/energydata_complete.csv"
curl -O $url
mv $(basename $url) data/
