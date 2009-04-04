args: with args;

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-5.0.77";

  src = fetchurl {
    url = http://downloads.mysql.com/archives/mysql-5.0/mysql-5.0.77.tar.gz;
    sha256 = "1s0m991aynim8ny28cfwhjw0ly8j5d72xi00461w6yc2hlaijcd9";
  };

  buildInputs = [ps ncurses zlib perl openssl];
  
  configureFlags = "--enable-thread-safe-client --disable-static --with-openssl=${openssl} --with-berkeley-db";

  postInstall =
    ''
      ln -s mysqld_safe $out/bin/mysqld
      rm -rf $out/mysql-test $out/sql-bench $out/share/info
    '';

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
  };
}
