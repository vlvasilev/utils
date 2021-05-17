#!/bin/bash

GARDEN=$1
SEED=$2


G_K=`gardenctl target garden $GARDEN-virtual`
S_K=`gardenctl target seed $SEED`

export G_K=$G_K
export S_K=$S_K
