source $stdenv/setup
ensureDir $out

unzip $src
mv ec2-api-tools-*/* $out

fixupPhase
