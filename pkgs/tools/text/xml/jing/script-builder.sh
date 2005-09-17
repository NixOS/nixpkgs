. $stdenv/setup || exit 1

mkdir -p $out/bin || exit 1

cat >> $out/bin/jing <<EOF
#! /bin/sh

export JAVA_HOME=$jre
export LANG="en_US"

$jre/bin/java -jar $jing/bin/jing.jar \$@
EOF

chmod a+x $out/bin/jing || exit 1
