source $stdenv/setup

unzip $src
cd axis2-*
ensureDir $out
cp -av * $out
cd webapp
ant
cd ..
ensureDir $out/webapps
cp dist/axis2.war $out/webapps
cd $out/webapps
mkdir axis2
cd axis2
unzip ../axis2.war
