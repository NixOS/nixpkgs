{ stdenv, fetchurl, openssl, libevent, c-ares, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.12.0";

  src = fetchurl {
    url = "https://pgbouncer.github.io/downloads/files/${version}/${pname}-${version}.tar.gz";
    sha256 = "0gi7ggmyjqd4kxdwm5csmzmjmfrjx7q20dfzk3da1bvc6xj6ag0v";
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
