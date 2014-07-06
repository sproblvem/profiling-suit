#!/bin/bash

CUR=`dirname "$0"`
CUR=`cd "$CUR"; pwd`

NOW=$2
#NOW=`date +%Y%m%d-%H%M%S-%N`

$CUR/shm check
SHMRTN=$?
#echo "shmnum : $SHMRTN" >> $CUR/debug
if [ "255" = $SHMRTN ]; then
    exit 0
fi

#ps -ef | awk -v pid=$1 -F" " '{if($3==pid) print $2" "$3}'
PID=`ps -ef | awk -v pid=$1 -F" " '{if($3==pid) print $2}'`
THREADS=$CUR/$NOW.$PID.pid
MONITOR=$CUR/info

$CUR/shm update
SHMRTN=$?

echo "work.sh $$ father $1 - child $PID shmnum : $SHMRTN" >> $THREADS

WATCH=`cat $CUR/watch-shmnum`
if [ $WATCH = $SHMRTN ]; then
    CMD="$CUR/perf-daemon/fifoclient $PID"
    #echo $CMD > $CUR/run-fifoclient
    $CMD
    #strace -o $CUR/check perf stat -ecache-misses -p $PID
    #(perf stat -ecache-misses -p $PID) > $CUR/stat.log 2>&1
fi
