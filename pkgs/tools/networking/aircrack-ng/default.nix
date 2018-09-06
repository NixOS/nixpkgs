{ stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools
, iw, ethtool, pciutils, libnl, pkgconfig, makeWrapper
, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "aircrack-ng-1.2";

  src = fetchurl {
    url = "https://download.aircrack-ng.org/${name}.tar.gz";
    sha256 = "0z7sl1ihgrnc98bpqa1mmkh51w26fnsanvj6ydwcnd8g83azwkvr";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper autoreconfHook ];
  buildInputs = [ libpcap openssl zlib libnl iw ethtool pciutils ];

  patchPhase = ''
    sed -e 's@/usr/local/bin@'${wirelesstools}@ -i src/osdep/linux.c
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
