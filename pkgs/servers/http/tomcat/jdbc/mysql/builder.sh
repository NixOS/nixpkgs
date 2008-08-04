source $stdenv/setup

ensureDir $out/shared/lib
ln -s $mysql_jdbc/share/java/mysql-connector-java.jar $out/shared/lib/mysql-connector-java.jar
