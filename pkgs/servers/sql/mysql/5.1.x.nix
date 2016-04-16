{ stdenv, fetchurl, ps, ncurses, zlib, perl, openssl }:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation rec {
  name = "mysql-5.1.73";

  src = fetchurl {
    url = "mirror://mysql/MySQL-5.1/${name}.tar.gz";
    sha256 = "1dfwi4ck0vq6sdci6gz0031s7zz5lc3pddqlgm0292s00l9y5sq5";
  };

  buildInputs = [ ncurses zlib perl openssl ] ++ stdenv.lib.optional stdenv.isLinux ps;

  configureFlags = [
    "--enable-thread-safe-client"
    "--with-ssl=${openssl.dev}"
    "--with-embedded-server"
    "--with-plugins=max-no-ndb"
    "--with-unix-socket-path=/run/mysqld/mysqld.sock"
  ] ++ stdenv.lib.optional (stdenv.system == "x86_64-linux") " --with-lib-ccflags=-fPIC";

  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";
  NIX_CFLAGS_CXXFLAGS = if stdenv.system == "x86_64-linux" then "-fPIC" else "";
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  patches = [ ./abi_check.patch ];

  postInstall =
    ''
      ln -s mysqld_safe $out/bin/mysqld
      rm -rf $out/mysql-test $out/sql-bench $out/share/info
    '';

  passthru.mysqlVersion = "5.1";

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
    platforms = stdenv.lib.platforms.all;
  };
}
