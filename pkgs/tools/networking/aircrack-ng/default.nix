{ stdenv, fetchurl, fetchpatch, libpcap, openssl, zlib, wirelesstools, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "aircrack-ng-1.2-rc4";

  src = fetchurl {
    url = "http://download.aircrack-ng.org/${name}.tar.gz";
    sha256 = "0dpzx9kddxpgzmgvdpl3rxn0jdaqhm5wxxndp1xd7d75mmmc2fnr";
  };

  buildInputs = [ libpcap openssl zlib libnl pkgconfig ];

  patches = [
    (fetchpatch {
      url = "https://trac.aircrack-ng.org/changeset/2882?format=diff&new=2882";
      name = "openssl-1.1.patch";
      sha256 = "11vk89jyd42l13i9y8l2p92p0cf4cdza40qpq75avvb7zqh3c2yi";
      stripLen = 2;
      addPrefixes = true;
    })
  ];

  postPatch = ''
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
