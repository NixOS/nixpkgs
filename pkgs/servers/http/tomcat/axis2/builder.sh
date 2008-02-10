buildInputs="$unzip $apacheAnt $jdk"
source $stdenv/setup

unzip $src
cd axis2-*/webapp
ant
ensureDir $out/webapps
cp ../dist/axis2.war $out/webapps
