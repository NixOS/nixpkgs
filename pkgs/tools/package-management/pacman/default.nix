{ stdenv, lib, fetchurl, autoreconfHook, pkgconfig, perl, libarchive, openssl,
zlib, bzip2, lzma }:

stdenv.mkDerivation rec {
  name = "pacman-${version}";
  version = "5.1.0";

  src = fetchurl {
    url = "https://git.archlinux.org/pacman.git/snapshot/pacman-${version}.tar.gz";
    sha256 = "1b545zvh661vkypnqr1cdicypym9d2kfvnxbf4a61qkyza6kzx35";
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
