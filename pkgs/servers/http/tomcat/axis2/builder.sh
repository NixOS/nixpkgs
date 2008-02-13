buildInputs="$unzip $apacheAnt $jdk"
source $stdenv/setup

unzip $src
cd axis2-*
ensureDir $out/share/java/axis2
cp lib/* $out/share/java/axis2
cd webapp
ant
ensureDir $out/webapps
cp ../dist/axis2.war $out/webapps
