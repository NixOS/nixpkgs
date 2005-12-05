source $stdenv/setup
genericBuild
cd $out/bin
ln -s bash sh
