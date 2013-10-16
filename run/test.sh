#!/bin/bash

NOW=`date +%Y%m%d%H%M%S`

NT="-D mapreduce.map.output.collector.delegator.class=org.apache.hadoop.mapred.nativetask.NativeMapOutputCollectorDelegator"

INPUT="/wc-input-4000000000-4"
OUTPUT="/wc_output_$NOW"

RUN="hadoop"
EXAMPLE="/usr/lib/hadoop/hadoop-examples-1.0.3-Intel.jar"

VTUNE="/tmp/vtune"

echo "ori-wordcount" > $VTUNE/setting
echo 8 > $VTUNE/watch-shmnum

$VTUNE/shm 0
echo "shmserver head!"
$RUN jar $EXAMPLE wordcount $NT $INPUT $OUTPUT 
$VTUNE/shm 255
echo "shmserver tail!"

sudo -u mapred cat $VTUNE/*.pid >> $VTUNE/thread
rm -rf $VTUNE/*.pid
rm -rf $VTUNE/once
echo "generate description done!"
