export PATH=/usr/bin:/bin

mkdir $out
cat > $out/setup <<EOF
export PATH=/usr/bin:/bin
export SHELL=/bin/sh
EOF
chmod +x $out/setup
