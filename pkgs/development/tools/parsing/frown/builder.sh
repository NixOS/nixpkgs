source $stdenv/setup

makeFlags="-e PREFIX=\"$out\""

ensureDir $out/bin

genericBuild
