if test -z "$out"; then
  out="$OUT"
  initialPath="$INITIALPATH"
  shell="$SHELL"
fi

setupPath=
for i in $initialPath; do
  setupPath=$setupPath${setupPath:+:}$i
done

PATH=$setupPath
export PATH

mkdir $out

cat > $out/setup <<EOF
PATH=$setupPath
export PATH

SHELL=$shell
export SHELL

# make fetchurl usable
header() {
  echo "\$1"
}

stopNest() {
  echo "Nothing to do"
}
EOF

chmod +x $out/setup
