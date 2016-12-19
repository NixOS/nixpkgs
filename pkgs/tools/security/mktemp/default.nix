{ stdenv, fetchurl, groff }:

stdenv.mkDerivation {
  name = "mktemp-1.6";

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  src = fetchurl {
    url = ftp://ftp.mktemp.org/pub/mktemp/mktemp-1.6.tar.gz;
    sha256 = "1nfj89b0dv1c2fyqi1pg54fyzs3462cbp7jv7lskqsxvqy4mh9x1";
  };
  
  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
