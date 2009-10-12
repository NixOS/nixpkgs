{stdenv, fetchurl, ps, ncurses, zlib, perl, openssl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-5.0.77";

  src = fetchurl {
    url = http://downloads.mysql.com/archives/mysql-5.0/mysql-5.0.77.tar.gz;
    sha256 = "1s0m991aynim8ny28cfwhjw0ly8j5d72xi00461w6yc2hlaijcd9";
  };

  buildInputs = [ps ncurses zlib perl openssl];
  
  configureFlags = "--enable-thread-safe-client --with-openssl=${openssl} --with-berkeley-db --with-embedded-server" +
    (if stdenv.system == "x86_64-linux" then " --with-lib-ccflags=-fPIC" else "");

  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";
  
  NIX_CFLAGS_CXXFLAGS = if stdenv.system == "x86_64-linux" then "-fPIC" else "";

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

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
