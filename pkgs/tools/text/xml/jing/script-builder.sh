. $stdenv/setup || exit 1

mkdir -p $out/bin || exit 1

cat >> $out/bin/jing <<EOF
#! /bin/sh

export JAVA_HOME=$j2re
export LANG="en_US"

$j2re/bin/java -jar $jing/bin/jing.jar \$@
EOF

chmod a+x $out/bin/jing || exit 1
