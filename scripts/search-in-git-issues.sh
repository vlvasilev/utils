#!/bin/bash

GREP_REGEX=$1

all_issues=$(ghi | awk 'If NR>1 {print $1}')

for issue in $all_issues; do
    grep_result=$(ghi show $issue | grep $GREP_REGEX)
    echo "ISSUE: $issue \n$grep_result"
    #if [[ ! -z "$grep_result" ]]; then
    #    echo "ISSUE: $issue \n$grep_result"
    #fi
done