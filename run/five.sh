#!/bin/bash

set -x 

#WORKLOADS="wordcount hivebench kmeans sort nutchindexing pagerank terasort bayes"
WORKLOADS="nutchindexing pagerank terasort bayes sort "
#WORKLOADS="bayes"

for workload in $WORKLOADS; do
	for i in `seq 5`; do
		echo $workload
		echo $i
		./run.sh $workload
		sleep 60
	done
	sleep 60
done
