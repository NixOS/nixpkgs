{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "exiftags";
  version = "1.01";

  src = fetchurl {
    url = "https://johnst.org/sw/exiftags/exiftags-${version}.tar.gz";
    sha256 = "194ifl6hybx2a5x8jhlh9i56k3qfc6p2l72z0ii1b7v0bzg48myr";
  };

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin $out/man/man1
  '';

  meta = {
    homepage = "http://johnst.org/sw/exiftags/";
    description = "Displays EXIF data from JPEG files";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; unix;
  };
}
