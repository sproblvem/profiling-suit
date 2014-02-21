#!/bin/bash

NOW=`date +%Y%m%d-%H%M%S-%N`
#A=`date +%s`

VER="spark-bsp"
CUR="/home/yama/bdas/$VER"

ALS_INPUT=/home/yama/bdas/incubator-spark/mllib/data/als/test.data 
ALS_INPUT=/home/yama/bdas/data/smallnetflix_mm.train_csv
ALS_OUTPUT=/tmp/als/

PR_INPUT="hdfs://linux-c0002:8020/spark/web-Google.txt"
PR_INPUT=/home/yama/bdas/data/web-small
PR_INPUT=/home/yama/bdas/data/web-Google.txt 

GD_INPUT=hdfs://queen:9000/xusen
GD_INPUT=/home/yama/data/epsilon_normalized-40000
GD_INPUT=/home/yama/data/epsilon_normalized
GD_INPUT=/home/yama/data/webspam_wc_normalized_unigram.svm

MLLIB=org.apache.spark.mllib

MASTER=local
MASTER=spark://queen:7077 

ITER=300
PART=176
STEP=2.0
RUN="bin/spark-class"

EXAMPLE_ALS="./run-example org.apache.spark.examples.SparkALS $MASTER 10"
MLLIB_ALS="./spark-class $MLLIB.recommendation.ALS $MASTER $ALS_INPUT 5 3 $ALS_OUTPUT"
PR="$CUR/bin/run-example org.apache.spark.examples.SparkPageRank $MASTER $PR_INPUT 3 60"

PARA5="$MASTER $GD_INPUT $STEP $ITER $PART"
PARA6="$MASTER $GD_INPUT $STEP 0.1 $ITER $PART"

DST=/tmp/spark-yama
LOG=$DST/log.tmp

declare -A inst
inst[LR_NEW]="$RUN $MLLIB.classification.LogisticRegressionWithSGD $PARA5"
inst[LR_OLD]="$RUN $MLLIB.classification.LogisticRegressionWithSGDAlt $PARA5"
inst[SVM_NEW]="$RUN $MLLIB.classification.SVMWithSGD $PARA6"
inst[SVM_OLD]="$RUN $MLLIB.classification.SVMWithSGDAlt $PARA6"
inst[LINEAR_NEW]="$RUN $MLLIB.regression.LinearRegressionWithSGD $PARA5"
inst[LINEAR_OLD]="$RUN $MLLIB.regression.LinearRegressionWithSGDAlt $PARA5"

function auto() {
	START=`date +%s`
	${inst[$1]} 2>&1 | tee $LOG
	FINISH=`date +%s`
	LOSS=`cat $LOG | grep "GradientDescent finished" | awk '{print $NF}'`
	REAL_PART=`cat $LOG | grep "TaskSchedulerImpl: Adding task set 1.0 with" | cut -d ' ' -f 10`
	echo >> $LOG;	cat conf/slaves >> $LOG
	echo >> $LOG;	cat conf/spark-env.sh >> $LOG
	echo >> $LOG;	echo ${inst[$1]} >> $LOG
	mv $LOG $DST/$START-$[$FINISH - $START]-${LOSS:0:5}-i$ITER-p$REAL_PART-s$STEP-$1.log
}

function step() {
	PARA5="$MASTER $GD_INPUT $STEP $ITER $PART"
	PARA6="$MASTER $GD_INPUT $STEP 0.1 $ITER $PART"
	local -A para
	para[LR_NEW]="$PARA5"
	para[LR_OLD]="$PARA5"
	para[SVM_NEW]="$PARA6"
	para[SVM_OLD]="$PARA6"
	para[LINEAR_NEW]="$PARA5"
	para[LINEAR_OLD]="$PARA5"

	COMM=`echo ${inst[$1]} | cut -d ' ' -f 1,2` 
	echo $COMM ${para[$1]}
	START=`date +%s`
	$COMM ${para[$1]} 2>&1 | tee $LOG
	FINISH=`date +%s`
	LOSS=`cat $LOG | grep "GradientDescent finished" | awk '{print $NF}'`
	REAL_PART=`cat $LOG | grep "TaskSchedulerImpl: Adding task set 1.0 with" | cut -d ' ' -f 10`
	echo >> $LOG;	cat conf/slaves >> $LOG
	echo >> $LOG;	cat conf/spark-env.sh >> $LOG
	echo >> $LOG;	echo ${inst[$1]} >> $LOG
	mv $LOG $DST/$START-$[$FINISH - $START]-${LOSS:0:5}-i$ITER-p$REAL_PART-s$STEP-$1.log
}

#for((ii=0; ii<5; ii++)); do
#done

#-------- do the real run --------

auto LR_NEW
sleep 3
auto LR_OLD
exit 0
