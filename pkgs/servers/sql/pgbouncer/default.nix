{ stdenv, fetchurl, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "pgbouncer-${version}";
  version = "1.8.1";

  src = fetchurl {
    url = "https://pgbouncer.github.io/downloads/files/${version}/${name}.tar.gz";
    sha256 = "1j4d7rkivg3vg27pvirigq9cy4v7pi48x7w57baq131c5lmdx2zs";
  };

  buildInputs = [ libevent openssl ];

  meta = with stdenv.lib; {
    homepage = https://pgbouncer.github.io;
    description = "Lightweight connection pooler for PostgreSQL";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
