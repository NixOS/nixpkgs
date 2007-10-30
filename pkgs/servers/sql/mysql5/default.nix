{stdenv, fetchurl, ps, ncurses, zlib ? null, perl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-5.0.45";

  src = fetchurl {
    url = http://downloads.mysql.com/archives/mysql-5.0/mysql-5.0.45.tar.gz;
    sha256 = "e4443d8dc859ed53bd9f3bef143ce30c7f5dee66a02748e9a003136be25e0060";
  };

  buildInputs = [ps ncurses zlib perl];

  configureFlags = "--enable-thread-safe-client";
}
