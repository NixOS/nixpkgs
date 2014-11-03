{ stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "aircrack-ng-1.2-beta3";

  src = fetchurl {
    url = "http://download.aircrack-ng.org/${name}.tar.gz";
    sha256 = "13g9xz9djjgfc2xi88vnx7zhgy751hqb3739y7znyihd6q9sw8id";
  };

  buildInputs = [ libpcap openssl zlib libnl pkgconfig ];

  patchPhase = ''
    sed -e 's@^prefix.*@prefix = '$out@ -i common.mak
    sed -e 's@/usr/local/bin@'${wirelesstools}@ -i src/osdep/linux.c
    '';

  meta = with stdenv.lib; {
    description = "Wireless encryption crackign tools";
    homepage = http://www.aircrack-ng.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ maintainers.iElectric maintainers.viric maintainers.garbas maintainers.chaoflow ];
    platforms = platforms.linux;
  };
}
