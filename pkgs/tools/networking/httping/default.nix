{
  fetchFromGitHub,
  fetchpatch,
  fftw ? null,
  gettext,
  lib,
  libintl,
  ncurses,
  openssl,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "httping";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = "HTTPing";
    rev = "refs/tags/v${version}";
    hash = "sha256-aExTXXtW03UKMuMjTMx1k/MUpcRMh1PdSPkDGH+Od70=";
  };

  patches = [
    # Pull upstream fix for missing <unistd.h>
    #   https://github.com/folkertvanheusden/HTTPing/pull/8
    (fetchpatch {
      name = "add-unistd.patch";
      url = "https://github.com/folkertvanheusden/HTTPing/commit/aad3c275686344fe9a235faeac4ee3832f3aa8d5.patch";
      hash = "sha256-bz3AMQTSfSTwUyf9WbkAFWVmFo06ei+Qd55x+RRDREY=";
    })
  ];

  nativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    fftw
    libintl
    ncurses
    openssl
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "ping with HTTP requests";
    homepage = "https://vanheusden.com/httping";
    license = licenses.agpl3Only;
    longDescription = ''
      Give httping an url, and it'll show you how long it takes to connect,
      send a request and retrieve the reply (only the headers). Be aware that
      the transmission across the network also takes time! So it measures the
      latency of the webserver + network. It supports IPv6.
    '';
    mainProgram = "httping";
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
