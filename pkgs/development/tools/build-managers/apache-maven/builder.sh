source $stdenv/setup

unpackPhase

mkdir -p $out
cp -r $name/* $out

wrapProgram $out/bin/mvn --set JAVA_HOME "$jdk"

# Add the maven-axis and JIRA plugin by default when using maven 1.x
if [ -e $out/bin/maven ]
then
  export OLD_HOME=$HOME
  export HOME=.
  $out/bin/maven plugin:download -DgroupId=maven-plugins -DartifactId=maven-axis-plugin -Dversion=0.7
  export HOME=OLD_HOME
fi
