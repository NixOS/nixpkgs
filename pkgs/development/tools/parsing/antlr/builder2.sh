source $stdenv/setup

tar zxvf $src
cd antlr-*

ensureDir $out/bin
ensureDir $out/lib/$name

cp antlr.jar $out/lib/$name

cat > $out/bin/antlr <<EOF
#! $SHELL
$jre/bin/java -cp $out/lib/$name/antlr.jar -Xms200M -Xmx400M antlr.Tool \$*
EOF

chmod u+x $out/bin/antlr
