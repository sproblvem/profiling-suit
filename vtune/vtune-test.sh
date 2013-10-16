#!/bin/bash

CUR=/tmp/vtune
NOW=`date +%Y%m%d-%H%M%S-%N`

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
COLLECT_OPT=snb-general-exploration         #General Exploration - Sandy Bridge / Ivy Bridge

NAME="$NOW-`cat $CUR/setting`-$COLLECT_OPT"

/opt/intel/vtune_amplifier_xe_2013/bin64/amplxe-cl -collect $COLLECT_OPT -user-data-dir $CUR -result-dir $NAME --target-pid $1 | tee $CUR/$NAME.log

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
