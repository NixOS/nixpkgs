{ stdenv, fetchurl, pkgconfig, curl, gpgme, libarchive, bzip2, lzma, attr, acl, libxml2
, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.3.3";
  name = "opkg-${version}";
  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "03nhz0ralc3cqsrwyc310n8kbk2m9im0m2r2za8lqphs29rrxnqr";
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
