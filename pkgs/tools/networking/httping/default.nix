{ stdenv, fetchurl, gettext, ncurses, openssl
, fftw ? null }:

stdenv.mkDerivation rec {
  name = "httping-${version}";
  version = "2.5";

  src = fetchurl {
    url = "https://www.vanheusden.com/httping/${name}.tgz";
    sha256 = "3e895a0a6d7bd79de25a255a1376d4da88eb09c34efdd0476ab5a907e75bfaf8";
  };

  buildInputs = [ fftw ncurses openssl ];
  nativeBuildInputs = [ gettext ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with stdenv.lib; {
    homepage = http://www.vanheusden.com/httping;
    description = "ping with HTTP requests";
    longDescription = ''
      Give httping an url, and it'll show you how long it takes to connect,
      send a request and retrieve the reply (only the headers). Be aware that
      the transmission across the network also takes time! So it measures the
      latency of the webserver + network. It supports IPv6.
    '';
    license     = licenses.agpl3;
    maintainers = with maintainers; [ nckx rickynils ];
    platforms   = platforms.linux;
  };
}
