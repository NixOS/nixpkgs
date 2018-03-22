{ stdenv, lib, fetchurl, autoreconfHook, pkgconfig, perl, libarchive, openssl,
zlib, bzip2, lzma }:

stdenv.mkDerivation rec {
  name = "pacman-${version}";
  version = "5.0.2";

  src = fetchurl {
    url = "https://git.archlinux.org/pacman.git/snapshot/pacman-${version}.tar.gz";
    sha256 = "1lk54k7d281v55fryqsajl4xav7rhpk8x8pxcms2v6dapp959hgi";
  };

  # trying to build docs fails with a2x errors, unable to fix through asciidoc
  configureFlags = [ "--disable-doc" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ perl libarchive openssl zlib bzip2 lzma ];

  meta = with lib; {
    description = "A simple library-based package manager";
    homepage = https://www.archlinux.org/pacman/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mt-caret ];
  };
}
