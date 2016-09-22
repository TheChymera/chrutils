#!/bin/bash

#if no size is specified we assume 100000x100000
SIZE=100000

# reads options:
while getopts ':s:t:' flag; do
  case "${flag}" in
    s)
      SIZE="$OPTARG"
      ;;
    t)
      TILE="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift $(($OPTIND - 1))
PDF=$1

BASENAME=$(basename "${PDF}")
NAME="${BASENAME%.*}"

REPETITIONS=$((SIZE / TILE -1))

for ((j=0; j<=${REPETITIONS}; j++))
	do
	JOFFSET=$((j * TILE))
	for ((i=0; i<=${REPETITIONS}; i++))
		do
		IOFFSET=$((i * TILE))
		gs -o ${NAME}_${i}_${j}.png -sDEVICE=pngalpha -g${TILE}x${TILE} -dLastPage=1 -c "<</Install {-${JOFFSET} -${IOFFSET} translate}>> setpagedevice" -f ${PDF}
		done
	done
