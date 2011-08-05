{stdenv, fetchurl, sqlite, zlib, acl, ncurses, openssl, readline}:

stdenv.mkDerivation {
  name = "bacula-5.0.3";

  src = fetchurl {
    url = mirror://sourceforge/bacula/bacula-5.0.3.tar.gz;
    sha256 = "1d7x6jw5x9ljbdxvcc8k635lsxcbxw9kzjyxf6l4zsdv3275j1cr";
  };

  buildInputs = [ sqlite zlib acl ncurses openssl readline ];

  configureFlags = [ "--with-sqlite3=${sqlite}" ];

  meta = {
    description = "Enterprise ready, Network Backup Tool";
    homepage = http://bacula.org/;
    license = "GPLv2";
  };
}
