#!/bin/bash

NOW=`date +%Y%m%d%H%M%S`
:<<note
JOB="bayes"
JOB="dfsioe"
JOB="hivebench"
JOB="kmeans"

JOB="sort"
JOB="nutchindexing"
JOB="pagerank"
JOB="terasort"
JOB="wordcount"
note
JOB=$1

:<<note
PTM="idh"
PTM="ori"
PTM="dit"
PTM="che"
note
PTM=UNKNOWN
NT=`cat /usr/lib/hadoop/conf/mapred-site.xml | grep "mapreduce.map.output.collector.delegator.class"`
if [ "x$NT" = "x" ]; then
	PTM="idh"
else
	PTM=`ls -l /usr/lib/hadoop/lib/native/Linux-amd64-64/libnativetask.so | cut -d "." -f 4`
fi

HIB="/home/yama/profile/HiBench-master/$JOB/bin"
PRE="$HIB/prepare.sh"
VTUNE="/tmp/vtune"

echo "$PTM-$JOB" > $VTUNE/setting
if [ $JOB = "pagerank" ]; then
	# jump the network build section
	echo 64 > $VTUNE/watch-shmnum
elif [ $JOB = "kmeans" ]; then
	echo 8 > $VTUNE/watch-shmnum
elif [ $JOB = "hivebench" ]; then
	echo 8 > $VTUNE/watch-shmnum
elif [ $JOB = "bayes" ]; then
	echo 70 > $VTUNE/watch-shmnum
else
	echo 8 > $VTUNE/watch-shmnum
fi

:<<note
# pagerank running web-google input
PR=/home/yama/profile/hadoop-twitter-pagerank/run-pr.sh
echo "idh-google-pagerank" > $VTUNE/setting
echo 32 > $VTUNE/watch-shmnum
note

sudo rm -rf $VTUNE/once

$VTUNE/shm 0
echo "shmserver head!"

#$PR
$HIB/run.sh

$VTUNE/shm 255
echo "shmserver tail!"

sudo chown yama:yama $VTUNE/thread
cat $VTUNE/*.pid >> $VTUNE/thread
sudo chown mapred:mapred $VTUNE/thread
echo "generate description done!"

rm -rf $VTUNE/*.pid
sudo rm -rf $VTUNE/once
$VTUNE/pack.sh

