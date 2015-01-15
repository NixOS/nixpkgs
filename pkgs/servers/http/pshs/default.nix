{ stdenv, fetchurl, pkgconfig, libevent, file, qrencode }:

let
  version = "0.2.5";
in stdenv.mkDerivation {
  name = "pshs-${version}";

  src = fetchurl {
    url = "https://www.bitbucket.org/mgorny/pshs/downloads/pshs-${version}.tar.bz2";
    sha256 = "1lbybww9b74a9ssrii15w6qby0d66j367kara7kmfhakpv8jsvyh";
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
