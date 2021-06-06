source $stdenv/setup

set -e

unzip $src
cd mysql-connector-java-*

mkdir -p $out/share/java
cp mysql-connector-java-*-bin.jar $out/share/java/mysql-connector-java.jar
