#!/bin/bash

DST=$1
STAFF="**.log *.pid desc"

if [ "x$DST" == "x" ]; then
	rm -rf $STAFF
else
	mv $STAFF $DST
fi

