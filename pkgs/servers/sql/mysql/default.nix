{stdenv, fetchurl, ps, ncurses, zlib ? null, perl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-4.1.12";

  src = fetchurl {
    url = http://dev.mysql.com/get/Downloads/MySQL-4.1/mysql-4.1.12.tar.gz/from/http://mysql.mirror.nedlinux.nl/;
    md5 = "56a6f5cacd97ae290e07bbe19f279af1";
  };

  buildInputs = [ps ncurses zlib perl];
}
