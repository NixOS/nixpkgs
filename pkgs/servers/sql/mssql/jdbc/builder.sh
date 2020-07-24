source $stdenv/setup

set -e

mkdir -p $out/share/java
cp $src $out/share/java/mssql-jdbc.jar
