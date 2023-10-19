{ lib, stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools
, iw, ethtool, pciutils, libnl, pkg-config, makeWrapper
, autoreconfHook, usbutils }:

stdenv.mkDerivation rec {
  pname = "aircrack-ng";
  version = "1.7";

  src = fetchurl {
    url = "https://download.aircrack-ng.org/aircrack-ng-${version}.tar.gz";
    sha256 = "1hsq1gwmafka4bahs6rc8p98yi542h9a502h64bjlygpr3ih99q5";
  };

  nativeBuildInputs = [ pkg-config makeWrapper autoreconfHook ];
  buildInputs = [ libpcap openssl zlib libnl iw ethtool pciutils ];

  patchPhase = ''
    sed -e 's@/usr/local/bin@'${wirelesstools}@ -i lib/osdep/linux.c
  '';

  postFixup = ''
    wrapProgram $out/bin/airmon-ng --prefix PATH : ${lib.makeBinPath [
      ethtool iw pciutils usbutils
    ]}
  '';

  meta = with lib; {
    description = "Wireless encryption cracking tools";
    homepage = "http://www.aircrack-ng.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
