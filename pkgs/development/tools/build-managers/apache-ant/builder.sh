source $stdenv/setup

tar jxf $src || exit 1
mkdir -p $out

mv apache-ant-*/* $out || exit 1

# add ant-contrib
cp $antContrib/*.jar $out/lib

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

# add ant script. This script is to be invoked with all
# appropiate variables and will try to be clever or user-friendly.

cat >> $out/bin/ant <<EOF
#! /bin/sh

export JAVA_HOME=$jdk
export JAVACMD=$jdk/bin/java
export LANG="en_US"

export ANT_HOME=$out
 
if [ -z "\$LOCALCLASSPATH" ] ; then
    LOCALCLASSPATH=\$ANT_HOME/lib/ant-launcher.jar
else
    LOCALCLASSPATH=\$ANT_HOME/lib/ant-launcher.jar:\$LOCALCLASSPATH
fi

if [ -n "\$JIKESPATH" ]; then
  exec "\$JAVACMD" \$NIX_ANT_OPTS \$ANT_OPTS -classpath "\$LOCALCLASSPATH" -Dant.home="\${ANT_HOME}" -Djikes.class.path="\$JIKESPATH" org.apache.tools.ant.launch.Launcher \$NIX_ANT_ARGS \$ANT_ARGS -lib "$CLASSPATH" "\$@"
else
  exec "\$JAVACMD" \$NIX_ANT_OPTS \$ANT_OPTS -classpath "\$LOCALCLASSPATH" -Dant.home="\${ANT_HOME}" org.apache.tools.ant.launch.Launcher \$NIX_ANT_ARGS \$ANT_ARGS -lib "$CLASSPATH" "\$@"
  fi
fi
EOF

chmod a+x $out/bin/ant

ln -s $out/bin/ant $out/bin/antRun

