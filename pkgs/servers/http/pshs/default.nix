{ stdenv, fetchurl, pkgconfig, libevent, file, qrencode, miniupnpc }:

let
  version = "0.3";
in stdenv.mkDerivation {
  name = "pshs-${version}";

  src = fetchurl {
    url = "https://www.bitbucket.org/mgorny/pshs/downloads/pshs-${version}.tar.bz2";
    sha256 = "0qvy1m9jmbjhbihs1qr9nasbaajl3n0x8bgz1vw9xvpkqymx5i63";
  };

  buildInputs = [ pkgconfig libevent file qrencode miniupnpc ];

  # SSL requires libevent at 2.1 with ssl support
  configureFlags = "--disable-ssl";

  meta = {
    description = "Pretty small HTTP server - a command-line tool to share files";
    homepage = "https://bitbucket.org/mgorny/pshs/";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
  };
}
