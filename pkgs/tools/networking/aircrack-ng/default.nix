{ stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools
, iw, ethtool, pciutils, libnl, pkgconfig, makeWrapper
, autoreconfHook, usbutils }:

stdenv.mkDerivation rec {
  name = "aircrack-ng-1.6";

  src = fetchurl {
    url = "https://download.aircrack-ng.org/${name}.tar.gz";
    sha256 = "0ix2k64qg7x3w0bzdsbk1m50kcpq1ws59g3zkwiafvpwdr4gs2sg";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper autoreconfHook ];
  buildInputs = [ libpcap openssl zlib libnl iw ethtool pciutils ];

  patchPhase = ''
    sed -e 's@/usr/local/bin@'${wirelesstools}@ -i lib/osdep/linux.c
  '';

  postFixup = ''
    wrapProgram $out/bin/airmon-ng --prefix PATH : ${stdenv.lib.makeBinPath [
      ethtool iw pciutils usbutils
    ]}
  '';

  meta = with stdenv.lib; {
    description = "Wireless encryption cracking tools";
    homepage = http://www.aircrack-ng.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.linux;
  };
}
