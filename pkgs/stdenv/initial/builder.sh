#! /bin/sh -e

export PATH=/usr/bin:/bin

mkdir $out
cat > $out/setup <<EOF
export PATH=/usr/bin:/bin
EOF
chmod +x $out/setup
