{ stdenv, fetchurl, pkgconfig, curl, gpgme, libarchive, bzip2, lzma, attr, acl, libxml2
, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.3.5";
  name = "opkg-${version}";
  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "0ciz6h6sx9hnz463alpkcqwqnq8jk382ifc6z89j29hix8fw4jvk";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ curl gpgme libarchive bzip2 lzma attr acl libxml2 ];

  meta = with stdenv.lib; {
    description = "A lightweight package management system based upon ipkg";
    homepage = http://code.google.com/p/opkg/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
