source $stdenv/setup

tar zxf $src

mkdir $out
mv apache-tomcat*/* $out
sed -i -e 's|shared.loader=|shared.loader=${catalina.base}/shared/lib/*.jar|' $out/conf/catalina.properties
