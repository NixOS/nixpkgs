. $stdenv/setup || exit 1

tar zxf $src || exit 1
mkdir -p $out/bin
mv jclasslib/bin/jclasslib.jar $out/bin/ || exit 1


cat >> $out/bin/jclasslib <<EOF
#! /bin/sh

export JAVA_HOME=$j2re

$j2re/bin/java -jar $out/bin/jclasslib.jar \$@
EOF

chmod a+x $out/bin/jclasslib || exit 1
