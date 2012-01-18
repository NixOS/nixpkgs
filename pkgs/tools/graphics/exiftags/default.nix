{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "exiftags-1.01";

  src = fetchurl {
    url = http://johnst.org/sw/exiftags/exiftags-1.01.tar.gz;
    sha256 = "194ifl6hybx2a5x8jhlh9i56k3qfc6p2l72z0ii1b7v0bzg48myr";
  };

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin $out/man/man1
  '';

  meta = {
    homepage = http://johnst.org/sw/exiftags/;
    description = "Displays EXIF data from JPEG files";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
