{ stdenv, fetchurl, nettools, pkgconfig, gtk3, libtool, perl }:

stdenv.mkDerivation rec {
  pname = "tme";
  version = "0.12beta37";

  src = fetchurl {
    url = "http://phabrics.com/tme-${version}.tar.xz";
    sha256 = "15x7as9daxjc6cwa099q9jldzzsvfdjc22ml83814mp3fnlizji2";
  };

  buildInputs = [ gtk3 libtool ];
  nativeBuildInputs = [ nettools pkgconfig perl ];

  preConfigure = ''
    substituteInPlace tmesh/Makefile.in \
      --replace "\$(MAKE) \$(AM_MAKEFLAGS) install-exec-hook" "\$(MAKE) \$(AM_MAKEFLAGS)"
  '';
}
