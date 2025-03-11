#! /bin/bash

awk 'BEGIN {OFS="\t"; print "GeneID","Chr","Start","End","Strand"} {start=$2+1; end=$3; print $1"_"start"_"end, $1, start, end, "+"}' random_peaks_for_normalization.bed > random_peaks_for_normalization.saf

