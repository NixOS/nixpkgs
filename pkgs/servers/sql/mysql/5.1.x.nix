{stdenv, fetchurl, ps, ncurses, zlib, perl, openssl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation rec {
  name = "mysql-5.1.72";

  src = fetchurl {
    url = "http://cdn.mysql.com/Downloads/MySQL-5.1/${name}.tar.gz";
    md5 = "ed79cd48e3e7402143548917813cdb80";
  };

  buildInputs = [ncurses zlib perl openssl] ++ stdenv.lib.optional stdenv.isLinux ps;

  configureFlags = "--enable-thread-safe-client --with-ssl=${openssl} --with-embedded-server --with-plugins=max-no-ndb" +
    (if stdenv.system == "x86_64-linux" then " --with-lib-ccflags=-fPIC" else "");

  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";
  NIX_CFLAGS_CXXFLAGS = if stdenv.system == "x86_64-linux" then "-fPIC" else "";
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  patches = [./abi_check.patch];

  postInstall =
    ''
      ln -s mysqld_safe $out/bin/mysqld
      rm -rf $out/mysql-test $out/sql-bench $out/share/info
    '';

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
    platforms = stdenv.lib.platforms.all;
  };
}
