{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils";
  version = "0.7";

  src = fetchurl {
    url = "http://dev.gentoo.org/~vapier/dist/${name}-${version}.tar.xz";
    sha256 = "111vmwn0ikrmy3s0w3rzpbzwrphawljrmcjya0isg5yam7lwxi0s";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=$(out)"
  ];

  meta = {
    description = "A suite of tools for PaX/grsecurity.";
    homepage = "http://dev.gentoo.org/~vapier/dist/";
    platforms = stdenv.lib.platforms.linux;
  };
}
