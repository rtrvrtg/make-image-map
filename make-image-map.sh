#!/bin/bash

# Rounding function
round() {
	echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
};

# Define a few basic variables. Usage is 
# ./make-image-map.sh inputfilename outputfileprefix
INPUT_IMAGE=$1
OUT_NAME=$2

# Use imagemagick to get width and height
START_WIDTH=$(identify -format '%[fx:w]' $INPUT_IMAGE)
START_HEIGHT=$(identify -format '%[fx:h]' $INPUT_IMAGE)

# More variables
END_WIDTH=0
END_HEIGHT=0
MAP_BASE=256
MAP_LARGEST=0
ZOOM=0

# Test if height is the bigger axis
if (( $START_HEIGHT > $START_WIDTH )); then
	echo "Start height is bigger"
	for i in {0..10}; do
		PWR=$(echo "2^$i" | bc)
		MAP_LARGEST=$(($MAP_BASE * $PWR))
		if (( $MAP_LARGEST >= $START_HEIGHT )); then
			END_HEIGHT=$MAP_LARGEST
			END_WIDTH=$(echo "$MAP_LARGEST / $START_HEIGHT * $START_WIDTH" | bc -l)
			END_WIDTH=$(round $END_WIDTH 0)
			ZOOM=$i
			break
		fi
	done
fi

# Test if height is the width axis
if (( $START_WIDTH > $START_HEIGHT )); then
	echo "Start width is bigger"
	for i in {0..10}; do
		PWR=$(echo "2^$i" | bc)
		MAP_LARGEST=$(($MAP_BASE * $PWR))
		if (( $MAP_LARGEST >= $START_WIDTH )); then
			END_WIDTH=$MAP_LARGEST
			END_HEIGHT=$(echo "$MAP_LARGEST/$START_WIDTH.0*$START_HEIGHT" | bc -l)
			END_HEIGHT=$(round $END_HEIGHT 0)
			ZOOM=$i
			break
		fi
	done
fi

echo "Preparing to render at $END_WIDTH x $END_HEIGHT"

# Resize image
gdal_translate -of JPEG -outsize $END_WIDTH $END_HEIGHT $INPUT_IMAGE $OUT_NAME.jpg
# Build tiles
gdal2tiles.py -p raster -z 0-$ZOOM -w none $OUT_NAME.jpg
# Convert all tiles to jpeg
find $OUT_NAME -iname '*.png' -exec mogrify -format jpg -background white -flatten {} +
# Delete all PNGs
find . -type f -name '*.png' -exec rm -f {} \;
