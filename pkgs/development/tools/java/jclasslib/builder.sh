source $stdenv/setup || exit 1

tar zxf $src || exit 1
cd jclasslib || exit 1

xpf-rm -f build.xml "//taskdef"

ant clean || exit 1
ant jar || exit 1

mkdir -p $out/bin
mv build/jclasslib.jar $out/bin/ || exit 1

cat >> $out/bin/jclasslib <<EOF
#! /bin/sh

export JAVA_HOME=$jre

$jre/bin/java -jar $out/bin/jclasslib.jar \$@
EOF

chmod a+x $out/bin/jclasslib || exit 1
