#!/bin/bash

for i in compiled/*.fst images/*.pdf; do
	echo "Removing file: compiled/$(basename $i '.fst')"
    rm $i
done