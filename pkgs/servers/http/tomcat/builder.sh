. $stdenv/setup || exit 1

tar zxf $src
mkdir $out
mv jakarta-tomcat* $out
