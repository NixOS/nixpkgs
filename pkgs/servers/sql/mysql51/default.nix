{stdenv, fetchurl, ps, ncurses, zlib, perl, openssl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-5.1.41";

  src = fetchurl {
    url = ftp://mirror.leaseweb.com/mysql/Downloads/MySQL-5.1/mysql-5.1.41.tar.gz;
    sha256 = "05mwinpq35iaglylw5n772vv2p1kxyni6f2hv081gxm58gdj3dsw";
  };

  buildInputs = [ps ncurses zlib perl openssl];

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
  };
}
