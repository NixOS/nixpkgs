#! /bin/sh

. $stdenv/setup

mkdir $out || exit 1

sed \
 -e "s^@preHook@^$preHook^g" \
 -e "s^@postHook@^$postHook^g" \
 -e "s^@initialPath@^$initialPath^g" \
 -e "s^@gcc@^$gcc^g" \
 -e "s^@param1@^$param1^g" \
 -e "s^@param2@^$param2^g" \
 -e "s^@param3@^$param3^g" \
 -e "s^@param4@^$param4^g" \
 -e "s^@param5@^$param5^g" \
 < $setup > $out/setup || exit 1
