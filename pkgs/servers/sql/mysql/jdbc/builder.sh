source $stdenv/setup

set -e

tar zxvf $src
cd mysql-connector-java-*

ensureDir $out/share/java
cp mysql-connector-java-*-bin.jar $out/share/java/mysql-connector-java.jar
