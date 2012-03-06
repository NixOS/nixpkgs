source $stdenv/setup

mkdir -p $out/jars
unzip -j $src '*/trang.jar'
cp -p *.jar $out/jars

mkdir -p $out/bin

cat >> $out/bin/trang <<EOF
#! $SHELL
export JAVA_HOME=$jre
exec $jre/bin/java -jar $out/jars/trang.jar "\$@"
EOF

chmod a+x $out/bin/trang
