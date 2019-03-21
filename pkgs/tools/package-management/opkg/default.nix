{ stdenv, fetchurl, pkgconfig, curl, gpgme, libarchive, bzip2, lzma, attr, acl, libxml2
, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "opkg-${version}";
  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "1zp6gyggqv359myagjsr0knq66ax64q3irx889kqzbd2v0ahbh7n";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ curl gpgme libarchive bzip2 lzma attr acl libxml2 ];

  meta = with stdenv.lib; {
    description = "A lightweight package management system based upon ipkg";
    homepage = https://git.yoctoproject.org/cgit/cgit.cgi/opkg/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
