#! /bin/sh

p1=$param1
p2=$param2
p3=$param3
p4=$param4
p5=$param5

. $stdenv/setup

mkdir $out || exit 1

sed \
 -e "s^@preHook@^$preHook^g" \
 -e "s^@postHook@^$postHook^g" \
 -e "s^@initialPath@^$initialPath^g" \
 -e "s^@gcc@^$gcc^g" \
 -e "s^@param1@^$p1^g" \
 -e "s^@param2@^$p2^g" \
 -e "s^@param3@^$p3^g" \
 -e "s^@param4@^$p4^g" \
 -e "s^@param5@^$p5^g" \
 < $setup > $out/setup || exit 1
