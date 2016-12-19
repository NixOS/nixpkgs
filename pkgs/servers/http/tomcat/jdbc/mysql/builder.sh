source $stdenv/setup

mkdir -p $out/lib
ln -s $mysql_jdbc/share/java/mysql-connector-java.jar $out/lib/mysql-connector-java.jar
