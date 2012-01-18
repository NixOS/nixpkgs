source $stdenv/setup

makeFlags="-e PREFIX=\"$out\""

mkdir -p $out/bin

genericBuild
