. $stdenv/setup

skip=165

mkdir $out

cd $out

tail +165 $src | tar xvfz -
