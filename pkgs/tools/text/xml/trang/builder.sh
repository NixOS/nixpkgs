source $stdenv/setup

ensureDir $out/jars
unzip -j $src '*/trang.jar'
cp -p *.jar $out/jars

ensureDir $out/bin

cat >> $out/bin/trang <<EOF
#! $SHELL
export JAVA_HOME=$jre
exec $jre/bin/java -jar $out/jars/trang.jar "\$@"
EOF

chmod a+x $out/bin/trang
