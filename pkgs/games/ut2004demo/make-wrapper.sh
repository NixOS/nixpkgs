source $stdenv/setup

mkdir -p $out/bin

cat > $out/bin/ut2004demo <<EOF
#! $SHELL -e

cd $raw/System

LD_LIBRARY_PATH=$libX11/lib:$libXext/lib\${LD_LIBRARY_PATH:+:}\$LD_LIBRARY_PATH ./ut2004-bin "\$@"
EOF

chmod +x $out/bin/ut2004demo
