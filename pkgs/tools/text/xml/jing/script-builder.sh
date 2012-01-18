source $stdenv/setup

mkdir -p $out/bin

cat >> $out/bin/jing <<EOF
#! $SHELL

export JAVA_HOME=$jre
export LANG="en_US"

exec $jre/bin/java -jar $jing/bin/jing.jar "\$@"
EOF

chmod a+x $out/bin/jing
