#! /bin/sh -e
. $stdenv/setup
installFlags="PREFIX=$out"
genericBuild
