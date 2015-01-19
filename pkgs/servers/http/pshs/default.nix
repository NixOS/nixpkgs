{ stdenv, fetchurl, pkgconfig, libevent, file, qrencode }:

let
  version = "0.2.6";
in stdenv.mkDerivation {
  name = "pshs-${version}";

  src = fetchurl {
    url = "https://www.bitbucket.org/mgorny/pshs/downloads/pshs-${version}.tar.bz2";
    sha256 = "0n8l5sjnwjqjmw0jzg3hb93n6npg2wahmdg1zrpsw8fyh9ggjg4g";
  };

  buildInputs = [ pkgconfig libevent file qrencode ];

  # TODO: enable ssl once dependencies
  # (libssl libcrypto libevent >= 2.1 libevent_openssl) can be met
  configureFlags = "--disable-ssl";

  meta = {
    description = "Pretty small HTTP server - a command-line tool to share files";
    homepage = "https://bitbucket.org/mgorny/pshs/";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
  };
}
