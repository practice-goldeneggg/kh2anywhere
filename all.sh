#!/bin/bash

usage() {
    cat <<-EOU
Usage: $0 [options]
Output your kindle highlights

Parameter Options:
  -m              Your kindle email
  -p              Your kindle password
  -h              Show this help

EOU
}

declare EMAIL
declare PASSWORD

while true
do
  case "$1" in
    -m | --mail ) EMAIL=${2}; shift 2 ;;
    -p | --password ) PASSWORD=${2}; shift 2 ;;
    -h | --help ) usage; exit 1 ;;
    * ) break ;;
  esac
done

if [ "${EMAIL}" = "" ]
then
  read -p "Input your kindle email?: " EMAIL
fi

if [ "${PASSWORD}" = "" ]
then
  read -sp "Input your kindle password?: " PASSWORD
fi

echo ""

if [ "${EMAIL}" = "" -o "${PASSWORD}" = "" ]
then
  echo "ERROR: need to your kindle email and password"
  exit 1
fi

# run and output highlight markdowns each books
KINDLE_EMAIL=${EMAIL} KINDLE_PASSWD=${PASSWORD} bundle ex ruby lib/kh2anywhere.rb

declare -r MD_DIR=mds
declare -r ALL_FILE=${MD_DIR}/all_highlights.md

if [ -f ${ALL_FILE} ]
then
  rm ${ALL_FILE}
fi

for md in ${MD_DIR}/*.md
do
  cat "${md}" >> ${ALL_FILE}
done
