. $stdenv/setup

mkdir $out
mkdir $out/bin

glibc=$(cat $NIX_GCC/nix-support/orig-glibc)

cat > $out/bin/ut2004demo <<EOF
#! $SHELL -e

cd $raw/System

LD_LIBRARY_PATH=$libX11/lib:$libXext/lib:/usr/lib:$mesa/lib $glibc/lib/ld-linux.so.2 ./ut2004-bin "\$@"
EOF

chmod +x $out/bin/ut2004demo
