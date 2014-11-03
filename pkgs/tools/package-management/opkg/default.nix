{ stdenv, fetchurl, pkgconfig, curl, gpgme }:

stdenv.mkDerivation rec {
  version = "0.2.3";
  name = "opkg-${version}";
  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "0qaczbw34az20vmh92h7fkswcgq7f6csajx35d4dljzfj85d8jcc";
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
