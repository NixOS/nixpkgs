{ stdenv, fetchurl, gettext, ncurses, openssl
, fftw ? null }:

stdenv.mkDerivation rec {
  name = "httping-${version}";
  version = "2.4";

  src = fetchurl {
    url = "http://www.vanheusden.com/httping/${name}.tgz";
    sha256 = "1110r3gpsj9xmybdw7w4zkhj3zmn5mnv2nq0ijbvrywbn019zdfs";
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
    maintainers = with maintainers; [ nckx rickynils ];
    platforms = platforms.linux;
  };
}
