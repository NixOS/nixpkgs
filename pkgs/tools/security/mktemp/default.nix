{ stdenv, fetchurl, groff }:

stdenv.mkDerivation {
  name = "mktemp-1.7";

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  # Don't use "install -s"
  postPatch = ''
    substituteInPlace Makefile.in --replace " 0555 -s " " 0555 "
  '';

  src = fetchurl {
    url = ftp://ftp.mktemp.org/pub/mktemp/mktemp-1.7.tar.gz;
    sha256 = "0x969152znxxjbj7387xb38waslr4yv6bnj5jmhb4rpqxphvk54f";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
