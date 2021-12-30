{ lib, stdenv, fetchurl, groff, mktemp, testVersion }:

stdenv.mkDerivation rec {
  pname = "mktemp";
  version = "1.7";

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  # Don't use "install -s"
  postPatch = ''
    substituteInPlace Makefile.in --replace " 0555 -s " " 0555 "
  '';

  src = fetchurl {
    url = "ftp://ftp.mktemp.org/pub/mktemp/mktemp-${version}.tar.gz";
    sha256 = "0x969152znxxjbj7387xb38waslr4yv6bnj5jmhb4rpqxphvk54f";
  };

  passthru.tests.version = testVersion { package = mktemp; };

  meta = with lib; {
    description = "Simple tool to make temporary file handling in shells scripts safe and simple";
    homepage = "https://www.mktemp.org";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
