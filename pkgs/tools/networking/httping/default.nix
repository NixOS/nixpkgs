{ lib, stdenv, fetchurl, fetchpatch, gettext, libintl, ncurses, openssl
, fftw ? null }:

stdenv.mkDerivation rec {
  pname = "httping";
  version = "2.5";

  src = fetchurl {
    url = "https://vanheusden.com/httping/${pname}-${version}.tgz";
    sha256 = "1y7sbgkhgadmd93x1zafqc4yp26ssiv16ni5bbi9vmvvdl55m29y";
  };

  patches = [
    # Upstream fix for ncurses-6.3.
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/folkertvanheusden/HTTPing/commit/4ea9d5b78540c972e3fe1bf44db9f7b3f87c0ad0.patch";
      sha256 = "0w3kdkq6c6hz1d9jjnw0ldvd6dy39yamj8haf0hvcyb1sb67qjmp";
    })
  ];

  buildInputs = [ fftw libintl ncurses openssl ];
  nativeBuildInputs = [ gettext ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    homepage = "https://vanheusden.com/httping";
    description = "ping with HTTP requests";
    longDescription = ''
      Give httping an url, and it'll show you how long it takes to connect,
      send a request and retrieve the reply (only the headers). Be aware that
      the transmission across the network also takes time! So it measures the
      latency of the webserver + network. It supports IPv6.
    '';
    license = licenses.agpl3;
    maintainers = [];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
