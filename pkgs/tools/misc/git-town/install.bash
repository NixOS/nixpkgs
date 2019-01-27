#!/bin/bash

source $stdenv/setup

mv $src git-town
mkdir -p $out/bin
install -m 0555 git-town $out/bin