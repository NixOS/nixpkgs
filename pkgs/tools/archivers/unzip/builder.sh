#! /bin/sh -e

. $stdenv/setup

builder() {
    make -f unix/Makefile generic
}

installer() {
    make -f unix/Makefile prefix=$out install
}

buildPhase=builder
installPhase=installer

genericBuild
