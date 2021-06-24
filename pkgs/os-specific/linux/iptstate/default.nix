{ lib, stdenv, fetchurl, libnetfilter_conntrack, ncurses }:

stdenv.mkDerivation rec {
  pname = "iptstate";
  version = "2.2.6";

  src = fetchurl {
    url = "https://github.com/jaymzh/iptstate/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "bef8eb67a4533e53079f397b71e91dd34da23f8cbd65cb2d5b67cb907b00c068";
  };

  buildInputs = [ libnetfilter_conntrack ncurses ];

  meta = with lib; {
    description = "Conntrack top like tool";
    homepage = "https://github.com/jaymzh/iptstate";
    platforms = platforms.linux;
    maintainers = with maintainers; [ trevorj ];
    downloadPage = "https://github.com/jaymzh/iptstate/releases";
    license = licenses.zlib;
  };

  installPhase = ''
    install -m755 -D iptstate $out/bin/iptstate
  '';
}

