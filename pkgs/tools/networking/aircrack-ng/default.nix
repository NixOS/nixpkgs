{ stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools
, iw, ethtool, pciutils, libnl, pkgconfig, makeWrapper
, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "aircrack-ng-1.4";

  src = fetchurl {
    url = "https://download.aircrack-ng.org/${name}.tar.gz";
    sha256 = "0fz1g6sd7dkfgcxrfrnqbygpx8d4ziyidm9wjb0ws9xgyy52l2cn";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper autoreconfHook ];
  buildInputs = [ libpcap openssl zlib libnl iw ethtool pciutils ];

  patchPhase = ''
    sed -e 's@/usr/local/bin@'${wirelesstools}@ -i src/aircrack-osdep/linux.c
  '';

  postFixup = ''
    wrapProgram $out/bin/airmon-ng --prefix PATH : ${stdenv.lib.makeBinPath [
      ethtool iw pciutils
    ]}
  '';

  meta = with stdenv.lib; {
    description = "Wireless encryption cracking tools";
    homepage = http://www.aircrack-ng.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ domenkozar garbas chaoflow ];
    platforms = platforms.linux;
  };
}
