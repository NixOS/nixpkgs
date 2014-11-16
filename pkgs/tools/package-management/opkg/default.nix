{ stdenv, fetchurl, pkgconfig, curl, gpgme }:

stdenv.mkDerivation rec {
  version = "0.2.4";
  name = "opkg-${version}";
  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "11ih8lay1v7sk5czk3m3cfqil4cp8s7pfz60xnddy7nqazjcfh0g";
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
