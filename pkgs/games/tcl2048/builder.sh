source $stdenv/setup

mkdir -p $out/bin
cp $src $out/bin/2048
chmod +x $out/bin/2048
