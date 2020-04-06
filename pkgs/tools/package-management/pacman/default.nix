{ stdenv, lib, fetchurl, pkgconfig, m4, perl, libarchive, openssl, zlib, bzip2,
lzma, curl, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "pacman";
  version = "5.2.1";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/${pname}/${pname}-${version}.tar.gz";
    sha256 = "04pkb8qvkldrayfns8cx4fljl4lyys1dqvlf7b5kkl2z4q3w8c0r";
  };

  enableParallelBuilding = true;

  configureFlags = [
    # trying to build docs fails with a2x errors, unable to fix through asciidoc
    "--disable-doc"

    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-scriptlet-shell=${runtimeShell}"
  ];

  installFlags = [ "sysconfdir=${placeholder "out"}/etc" ];

  nativeBuildInputs = [ pkgconfig m4 ];
  buildInputs = [ curl perl libarchive openssl zlib bzip2 lzma ];

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
