{ stdenv, fetchurl, pkgconfig, curl, gpgme, libarchive, bzip2, lzma, attr, acl, libxml2
, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.4.2";
  pname = "opkg";
  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "01p1a7hw9q9ixfk01djyy9axs71z1x9dkdnqz7zysmrlqi97i246";
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
