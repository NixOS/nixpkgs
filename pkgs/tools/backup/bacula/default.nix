{stdenv, fetchurl, sqlite, zlib, acl, ncurses, openssl, readline}:

stdenv.mkDerivation {
  name = "bacula-5.2.13";

  src = fetchurl {
    url = mirror://sourceforge/bacula/bacula-5.2.13.tar.gz;
    sha256 = "1n3sc0kd7r0afpyi708y3md0a24rbldnfcdz0syqj600pxcd9gm4";
  };

  buildInputs = [ sqlite zlib acl ncurses openssl readline ];

  configureFlags = [ "--with-sqlite3=${sqlite}" ];

  meta = {
    description = "Enterprise ready, Network Backup Tool";
    homepage = http://bacula.org/;
    license = "GPLv2";
  };
}
