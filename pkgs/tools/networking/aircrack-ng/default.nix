{ stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "aircrack-ng-1.2-rc4";

  src = fetchurl {
    url = "http://download.aircrack-ng.org/${name}.tar.gz";
    sha256 = "0dpzx9kddxpgzmgvdpl3rxn0jdaqhm5wxxndp1xd7d75mmmc2fnr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpcap openssl zlib libnl ];

  patchPhase = ''
    sed -e 's@^prefix.*@prefix = '$out@ -i common.mak
    sed -e 's@/usr/local/bin@'${wirelesstools}@ -i src/osdep/linux.c
    '';

  meta = with stdenv.lib; {
    description = "Wireless encryption cracking tools";
    homepage = http://www.aircrack-ng.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ domenkozar viric garbas chaoflow nckx ];
    platforms = platforms.linux;
  };
}
