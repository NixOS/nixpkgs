if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

unpackPhase

mkdir -p $out/maven
cp -r $name/* $out/maven

makeWrapper $out/maven/bin/mvn $out/bin/mvn --set-default JAVA_HOME "$jdk"
makeWrapper $out/maven/bin/mvnDebug $out/bin/mvnDebug --set-default JAVA_HOME "$jdk"

# Add the maven-axis and JIRA plugin by default when using maven 1.x
if [ -e $out/maven/bin/maven ]
then
  export OLD_HOME=$HOME
  export HOME=.
  $out/maven/bin/maven plugin:download -DgroupId=maven-plugins -DartifactId=maven-axis-plugin -Dversion=0.7
  export HOME=OLD_HOME
fi
