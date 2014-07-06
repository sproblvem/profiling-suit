#!/bin/bash

CUR=`dirname "$0"`
CUR=`cd "$CUR"; pwd`
NOW=`date +%Y%m%d-%H%M%S-%N` 
EVENT="cache-misses,cache-references,ref-cycles,stalled-cycles-frontend,stalled-cycles-backend,cycles,instructions,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-dcache-prefetch-misses,L1-icache-load-misses,LLC-loads,LLC-stores,LLC-prefetches,dTLB-loads,dTLB-load-misses,dTLB-stores,dTLB-store-misses,iTLB-loads,iTLB-load-misses,branch-loads,branch-load-misses"

(perf stat -e $EVENT -p $1) > $CUR/stat.log 2>&1 &
PID=$!

while [ -e /proc/$1 ]; do 
	sleep 0.1; 
done

kill -2 $PID

:<<note
start=`date +%s`
finish=`date +%s`
echo $[$finish - $start] > $CUR/elapse-time
note
