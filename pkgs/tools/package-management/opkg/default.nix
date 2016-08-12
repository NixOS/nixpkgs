{ stdenv, fetchurl, pkgconfig, curl, gpgme, libarchive, bzip2, lzma, attr, acl, libxml2
, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.3.1";
  name = "opkg-${version}";
  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "1pw7igmb4miyxl11sj9g8p8pgxg9nmn1h2hzi8b23v44hcmc1inj";
  };

  buildInputs = [ pkgconfig curl gpgme libarchive bzip2 lzma attr acl libxml2
    autoreconfHook ];

  meta = with stdenv.lib; {
    description = "A lightweight package management system based upon ipkg";
    homepage = http://code.google.com/p/opkg/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
