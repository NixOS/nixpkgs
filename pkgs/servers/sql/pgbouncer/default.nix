{ stdenv, fetchurl, openssl, libevent, c-ares, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.14.0";

  src = fetchurl {
    url = "https://pgbouncer.github.io/downloads/files/${version}/${pname}-${version}.tar.gz";
    sha256 = "1rzy06hqzhnijm32vah9icgrx95pmf9iglvyzwv7wmcg2h83vhd0";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl c-ares ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://pgbouncer.github.io";
    description = "Lightweight connection pooler for PostgreSQL";
    license = licenses.isc;
    platforms = platforms.all;
  };
}
