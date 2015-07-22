{ stdenv, fetchurl, pkgconfig, curl, gpgme, libarchive, bzip2, lzma, attr, acl }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "opkg-${version}";
  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "13wqai7lgyfjlqvly0bz786wk9frl16a9yzrn27p3wwfvcf5swvz";
  };

  buildInputs = [ pkgconfig curl gpgme libarchive bzip2 lzma attr acl ];

  meta = with stdenv.lib; {
    description = "A lightweight package management system based upon ipkg";
    homepage = http://code.google.com/p/opkg/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
