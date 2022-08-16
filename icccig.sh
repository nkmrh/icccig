#!/bin/bash

CMD=$(basename $0 .sh)
EXPORT_DIR='./promocodes'
FONT_DIR='./font'
TEMP="tmp-$(date | md5).jpg"

usage() {
  echo "usage: $CMD [filename]"
  echo
  echo "filename: e.g. \"promocodes.txt\" downloaded from iTunesConnect."
  echo "          Read from standard input if no file is specified."
}

check_file_exists() {
  if [ ! -e $1 ]; then
    echo "'$1' does not exist"
    exit 1
  fi
}

check_command_exists() {
  command -v $1 > /dev/null
  if [ $? -ne 0 ]; then
      echo "$CMD requires '$1' command installed"
      exit 1
  fi
}

write_image_from_code() {
  code=$1
  images=()
  for i in $(seq 1 ${#code}); do
    images+=("${FONT_DIR}/${code:$i-1:1}.jpg")
  done
  margin='25x25'
  border='2x2'
  convert +append "${images[@]}" $TEMP
  convert $TEMP -background white -gravity northwest -splice $margin $TEMP
  convert $TEMP -background white -gravity southeast -splice $margin $TEMP
  convert $TEMP -bordercolor black -border $border "${EXPORT_DIR}/${code}.jpg"
  rm $TEMP
}

check_command_exists convert
if [ -p /dev/stdin ] && [ $# -eq 0 ]; then
  mkdir -p $EXPORT_DIR
  { read code; }
  write_image_from_code $code
  echo "${EXPORT_DIR}/${code}.jpg"
elif [ $# -eq 1 ]; then
  if [ $1 = "-h" ] || [ $1 = "--help" ] || [ $1 = "help" ]; then
    usage
    exit 0
  fi
  mkdir -p $EXPORT_DIR
  while read -r code; do
    write_image_from_code $code
  done < $1
else
  usage
  exit 1
fi
