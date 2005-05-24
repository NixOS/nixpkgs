. $stdenv/setup

set -e

tar zxvf $src
cd postgresql-jdbc-*
ant

ensureDir $out/share/java
cp jars/*.jar $out/share/java
