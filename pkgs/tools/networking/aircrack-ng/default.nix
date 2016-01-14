{ stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "aircrack-ng-1.2-rc3";

  src = fetchurl {
    url = "http://download.aircrack-ng.org/${name}.tar.gz";
    sha256 = "11a53acln0fpar6v75qlybzdg8hdwc9ssd06fxygr47yp755qncf";
  };

  buildInputs = [ libpcap openssl zlib libnl pkgconfig ];

  patchPhase = ''
    sed -e 's@^prefix.*@prefix = '$out@ -i common.mak
    sed -e 's@/usr/local/bin@'${wirelesstools}@ -i src/osdep/linux.c
    '';

  meta = with stdenv.lib; {
    description = "Wireless encryption cracking tools";
    homepage = http://www.aircrack-ng.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ iElectric viric garbas chaoflow nckx ];
    platforms = platforms.linux;
  };
}
