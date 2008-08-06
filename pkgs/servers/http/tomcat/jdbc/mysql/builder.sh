source $stdenv/setup

ensureDir $out/lib
ln -s $mysql_jdbc/share/java/mysql-connector-java.jar $out/lib/mysql-connector-java.jar
