source $stdenv/setup

tar zxf $src

mkdir $out
mv apache-tomcat-*/* $out
