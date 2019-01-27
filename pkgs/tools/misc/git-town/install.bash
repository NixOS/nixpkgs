#!/bin/bash

source $stdenv/setup

export PATH=$go/bin:$PATH
mkdir -p go/src/github.com/Originate
mkdir -p go/bin

export GOPATH=`pwd`/go

tar xf $src
mv git-town-$version $GOPATH/src/github.com/Originate/git-town

cd $GOPATH/src/github.com/Originate/git-town

# make setup
make build

mkdir -p $out/bin
install -m 0555 $GOPATH/bin/git-town $out/bin


