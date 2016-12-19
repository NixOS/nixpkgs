source $stdenv/setup

unzip $src
cd axis2-*
mkdir -p $out
cp -av * $out
cd webapp
ant
cd ..
mkdir -p $out/webapps
cp dist/axis2.war $out/webapps
cd $out/webapps
mkdir axis2
cd axis2
unzip ../axis2.war
