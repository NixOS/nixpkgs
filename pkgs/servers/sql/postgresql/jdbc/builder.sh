source $stdenv/setup

set -e

tar zxvf $src
cd postgresql-jdbc-*
ant

mkdir -p $out/share/java
cp jars/*.jar $out/share/java
