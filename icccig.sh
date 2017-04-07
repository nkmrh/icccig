#!/bin/bash

EXPORT_DIR='./images'
FONT_DIR='./font'
PROMOCODES='promocodes.txt'
TEMP='tmp.jpg'
MARGIN='25x25'
BORDER='2x2'

mkdir -p $EXPORT_DIR

while read -r code; do
  images=()
  for i in $(seq 1 ${#code}); do
    images+=("${FONT_DIR}/${code:$i-1:1}.jpg")
  done
  convert +append "${images[@]}" $TEMP
  convert $TEMP -background white -gravity northwest -splice $MARGIN $TEMP
  convert $TEMP -background white -gravity southeast -splice $MARGIN $TEMP
  convert $TEMP -bordercolor black -border $BORDER "${EXPORT_DIR}/${code}.jpg"
done < $PROMOCODES

rm $TEMP
