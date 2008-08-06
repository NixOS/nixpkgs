source $stdenv/setup

tar zxf $src

mkdir $out
mv apache-tomcat*/* $out

# Rename the context.xml to context.xml.default in order to allow a custom context.xml
mv $out/conf/context.xml $out/conf/context.xml.default

# Change all references from CATALINA_HOME to CATALINA_BASE and add support for shared libraries
sed -i -e 's|${catalina.home}|${catalina.base}|g' \
       -e 's|shared.loader=|shared.loader=${catalina.base}/shared/lib/*.jar|' $out/conf/catalina.properties
