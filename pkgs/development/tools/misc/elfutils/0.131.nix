args: with args;

stdenv.mkDerivation {
  name = "elfutils-"+version;
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/e/elfutils/elfutils_0.131.orig.tar.gz;
    sha256 = "0vqfjpcv81m3q0gsk78qykakhz9rbfwd65i4zsi03xr2lrk9ayll";
  };
  dontAddDisableDepTrack = "true";
  preBuild = "sed -e 's/-Werror//' -i */Makefile ";
}
