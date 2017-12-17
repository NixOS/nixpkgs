{ stdenv, fetchurl, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "pgbouncer-${version}";
  version = "1.7.2";

  src = fetchurl {
    url = "https://pgbouncer.github.io/downloads/files/${version}/${name}.tar.gz";
    sha256 = "de36b318fe4a2f20a5f60d1c5ea62c1ca331f6813d2c484866ecb59265a160ba";
  };

  buildInputs = [ libevent openssl ];

  meta = with stdenv.lib; {
    homepage = https://pgbouncer.github.io;
    description = "Lightweight connection pooler for PostgreSQL";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
