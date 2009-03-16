args: with args;

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-5.0.77";

  src = fetchurl {
    url = http://downloads.mysql.com/archives/mysql-5.0/mysql-5.0.77.tar.gz;
    sha256 = "1s0m991aynim8ny28cfwhjw0ly8j5d72xi00461w6yc2hlaijcd9";
  };

  buildInputs = [ps ncurses zlib perl openssl];
  postInstall = "ln -s mysqld_safe $out/bin/mysqld";

  configureFlags = "--enable-thread-safe-client --with-embedded-server --disable-static --with-openssl=${openssl} --with-berkeley-db";
}
