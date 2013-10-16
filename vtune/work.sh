#!/bin/bash

CUR=/tmp/vtune
NOW=$2
#NOW=`date +%Y%m%d-%H%M%S-%N`

$CUR/shm check
SHMRTN=$?
#echo "shmnum : $SHMRTN" >> $CUR/debug
if [ "255" = $SHMRTN ]; then
	exit 0
fi

THREADS=$CUR/$NOW.$$.pid
MONITOR=$CUR/thread

PID=(`jps | grep "$1 Child" | cut -d " " -f 1`)
#echo "pid : $PID" >> $CUR/debug

if [ "x$PID" = "x" ]; then
    echo "$NOW $1" >> $THREADS
    exit 0
else
    echo -n "$NOW $1 child - ${PID[*]} shmnum : " >> $THREADS
fi

$CUR/shm update
SHMRTN=$?
echo $SHMRTN >> $THREADS
WATCH=`cat $CUR/watch-shmnum`
#echo $WATCH >> $CUR/debug
#echo $SHMRTN >> $CUR/debug
if [ $WATCH = $SHMRTN ] && [ ! -e $CUR/once ]; then
	touch $CUR/once
	echo "profile process $PID success!" >> $MONITOR
	echo >> $MONITOR
else
	exit 0
fi

:<<note
COLLECT_OPT=advanced-hotspots               #Advanced Hotspots
COLLECT_OPT=concurrency                     #Concurrency
COLLECT_OPT=frequency                       #CPU Frequency
COLLECT_OPT=hotspots                        #Basic Hotspots
COLLECT_OPT=locksandwaits                   #Locks and Waits
COLLECT_OPT=sleep                           #CPU Sleep States

COLLECT_OPT=snb-access-contention           #Access Contention - Sandy Bridge / Ivy Bridge
COLLECT_OPT=snb-bandwidth                   #Bandwidth - Sandy Bridge / Ivy Bridge
COLLECT_OPT=snb-branch-analysis             #Branch Analysis - Sandy Bridge / Ivy Bridge
COLLECT_OPT=snb-client                      #Client Analysis - Sandy Bridge / Ivy Bridge
COLLECT_OPT=snb-core-port-saturation        #Core Port Saturation - Sandy Bridge / Ivy Bridge
COLLECT_OPT=snb-cycles-uops                 #Cycles and uOps - Sandy Bridge / Ivy Bridge
COLLECT_OPT=snb-general-exploration         #General Exploration - Sandy Bridge / Ivy Bridge
COLLECT_OPT=snb-memory-access               #Memory Access - Sandy Bridge / Ivy Bridge
COLLECT_OPT=snb-port-saturation             #Port Saturation - Sandy Bridge / Ivy Bridge
note
COLLECT_OPT=snb-bandwidth                   #Bandwidth - Sandy Bridge / Ivy Bridge

NAME="$NOW-`cat $CUR/setting`-$COLLECT_OPT"

/opt/intel/vtune_amplifier_xe_2013/bin64/amplxe-cl -collect $COLLECT_OPT -user-data-dir $CUR -result-dir $NAME --target-pid $PID 2>&1 | tee $CUR/$NAME.log

:<<note
vtune arguements

-verbose
-knob collection-detail=stack-and-callcount 
-app-wrokingdir

--duration 30
1 min
-target-duration-type=veryshort
1 - 15 min
nothing
15 - 300 min
-target-duration-type=medium
larger than 300 min
-target-duration-type=long
note
