. $stdenv/setup || exit 1

mkdir -p $out/bin || exit 1

cat >> $out/bin/ant <<EOF
#! /bin/sh

export JAVA_HOME=$j2sdk
export JAVACMD=$j2sdk/bin/java
export ANT_OPTS=""
export ANT_ARGS=""

$ant/bin/core-ant
EOF

chmod a+x $out/bin/ant || exit 1
