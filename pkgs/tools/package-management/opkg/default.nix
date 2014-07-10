{ stdenv, fetchurl, pkgconfig, curl, gpgme }:

stdenv.mkDerivation rec {
  version = "0.2.2";
  name = "opkg-${version}";
  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "0ax10crp2grrpl20gl5iqfw37d5qz6h790lyyv2ali45agklqmda";
  };

  buildInputs = [ pkgconfig curl gpgme ];

  meta = with stdenv.lib; {
    description = "A lightweight package management system based upon ipkg";
    homepage = http://code.google.com/p/opkg/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
