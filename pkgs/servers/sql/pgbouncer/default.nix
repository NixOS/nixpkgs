{ stdenv, fetchurl, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "pgbouncer-${version}";
  version = "1.9.0";

  src = fetchurl {
    url = "https://pgbouncer.github.io/downloads/files/${version}/${name}.tar.gz";
    sha256 = "012zh9l68r1ramrd66yam6y3al0i85dvvg4wwwkn6qwq6dhskv1r";
  };

  buildInputs = [ libevent openssl ];

  meta = with stdenv.lib; {
    homepage = https://pgbouncer.github.io;
    description = "Lightweight connection pooler for PostgreSQL";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
