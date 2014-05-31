#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
format=wav
output_file=~/.music_hack/audio.$format
if [[ -n "$1" ]]; then
	bits="--bits $1"
else
	bits="--bits 16"
fi
recorder_process='Grabbr.app/Contents/SharedSupport/sox'
pid=`ps -axo pid,command,args | grep $recorder_process | grep -v grep | awk '{ print $1 }'`
if [[ -z $pid ]]; then
  $DIR/sox -V6 -t coreaudio 'Grabbr' $bits $output_file 2>&1 >> /dev/null
fi
