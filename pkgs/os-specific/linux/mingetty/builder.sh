source $stdenv/setup

echo $out

export DESTDIR=$out

genericBuild

