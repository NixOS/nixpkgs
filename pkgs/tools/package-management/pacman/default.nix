{ stdenv, lib, fetchurl, autoreconfHook, pkgconfig, perl, libarchive, openssl,
zlib, bzip2, lzma }:

stdenv.mkDerivation rec {
  name = "pacman-${version}";
  version = "5.1.3";

  src = fetchurl {
    url = "https://git.archlinux.org/pacman.git/snapshot/pacman-${version}.tar.gz";
    sha256 = "108xp6dhvp02jnzskhgzjmp9jvrxhhkffvmpvs3rrif7vj47xd76";
  };

  configureFlags = [
    # trying to build docs fails with a2x errors, unable to fix through asciidoc
    "--disable-doc"

    "--localstatedir=/var"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ perl libarchive openssl zlib bzip2 lzma ];

  postFixup = ''
    substituteInPlace $out/bin/repo-add \
      --replace bsdtar "${libarchive}/bin/bsdtar"
  '';

  meta = with lib; {
    description = "A simple library-based package manager";
    homepage = https://www.archlinux.org/pacman/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mt-caret ];
  };
}
