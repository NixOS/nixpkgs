. $stdenv/setup || exit 1

# unpack the binary distribution
tar jxf $src || exit 1
mkdir -p $out
mv apache-ant-*/* $out || exit 1

# remove crap in the root directory

for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done
rm -rf $out/docs

# prevent the use of hacky scripts. This will be handled in Nix.
rm $out/bin/* || exit 1

# add core-ant script. This script is to be invoked with all
# appropiate variables and will try to be clever or user-friendlt=y.

cat >> $out/bin/core-ant <<EOF
#! /bin/sh


# Variables:
#   JAVA_HOME
#   JAVACMD
#   ANT_OPTS
#   ANT_ARGS

ANT_HOME=$out
 
if [ -z "\$LOCALCLASSPATH" ] ; then
    LOCALCLASSPATH=\$ANT_HOME/lib/ant-launcher.jar
else
    LOCALCLASSPATH=\$ANT_HOME/lib/ant-launcher.jar:\$LOCALCLASSPATH
fi

if [ -n "\$JIKESPATH" ]; then
  exec "\$JAVACMD" \$ANT_OPTS -classpath "\$LOCALCLASSPATH" -Dant.home="\${ANT_HOME}" -Djikes.class.path="\$JIKESPATH" org.apache.tools.ant.launch.Launcher \$ANT_ARGS -lib "$CLASSPATH" "\$@"
else
  exec "\$JAVACMD" \$ANT_OPTS -classpath "\$LOCALCLASSPATH" -Dant.home="\${ANT_HOME}" org.apache.tools.ant.launch.Launcher \$ANT_ARGS -lib "$CLASSPATH" "\$@"
  fi
fi
EOF

chmod a+x $out/bin/core-ant

