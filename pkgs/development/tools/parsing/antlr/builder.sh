source $stdenv/setup

tar zxvf $src
cd antlr-*
cd lib

ensureDir $out/lib/antlr
ensureDir $out/bin

cp *.jar $out/lib/antlr

classpath=""
for jar in $out/lib/antlr/*.jar; do
  classpath="$classpath:$jar"
done

cat > $out/bin/antlr <<EOF
#! $SHELL

$jre/bin/java -cp $classpath -Xms200M -Xmx400M org.antlr.Tool \$*
EOF

chmod u+x $out/bin/antlr
