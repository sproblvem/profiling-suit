#!/bin/bash

VTUNE=/tmp/vtune

if [ -f $VTUNE/thread ]; then
	sudo -u mapred mv $VTUNE/watch-shmnum $VTUNE/setting $VTUNE/thread $VTUNE/*.log $VTUNE/`ls $VTUNE | grep .log | cut -d "." -f 1`
fi
