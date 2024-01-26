if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

tar zxvf $src
cd antlr-*
cd lib

mkdir -p $out/lib/antlr
mkdir -p $out/bin

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
