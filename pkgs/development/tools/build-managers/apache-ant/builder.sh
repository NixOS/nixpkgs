. $stdenv/setup || exit 1

mkdir -p $out/bin || exit 1

cat >> $out/bin/ant <<EOF
#! /bin/sh

export JAVA_HOME=$jdk
export JAVACMD=$jdk/bin/java
export ANT_OPTS=""
export ANT_ARGS=""
export LANG="en_US"

$ant/bin/core-ant \$@
EOF

chmod a+x $out/bin/ant || exit 1
