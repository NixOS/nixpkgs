{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "elfutils-0.131";
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/e/elfutils/elfutils_0.131.orig.tar.gz;
    sha256 = "0vqfjpcv81m3q0gsk78qykakhz9rbfwd65i4zsi03xr2lrk9ayll";
  };
}
