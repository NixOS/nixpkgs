#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1
cd $out || exit 1
tar xvfj $src || exit 1
mv extralite/* . || exit 1
rmdir extralite || exit 1
