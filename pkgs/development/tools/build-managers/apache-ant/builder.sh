source $stdenv/setup

mkdir -p $out/bin

cat >> $out/bin/ant <<EOF
#! /bin/sh

export JAVA_HOME=$jdk
export JAVACMD=$jdk/bin/java
export ANT_OPTS=""
export ANT_ARGS=""
export LANG="en_US"

$ant/bin/core-ant \$@
EOF

chmod a+x $out/bin/ant

ln -s $ant/lib $ant/etc $out/


