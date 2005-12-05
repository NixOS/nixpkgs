source $stdenv/setup

mkdir $out
mkdir $out/bin
mkdir $out/links

ln -s $raw/* $out/links
ln -s $out/links/bin/x86/glibc-2.1/q3demo $out/links/q3demo

glibc=$(cat $NIX_GCC/nix-support/orig-glibc)

cat > $out/bin/q3ademo <<EOF
#! $SHELL -e
LD_LIBRARY_PATH=$libX11/lib:$libXext/lib:$mesa/lib $glibc/lib/ld-linux.so.2 $out/links/q3demo "\$@" +set s_initsound 0
EOF

chmod +x $out/bin/q3ademo
