{stdenv, fetchurl, which, libjpeg
, withQt4 ? false, qt4 ? null}:

assert withQt4 -> qt4 != null;

stdenv.mkDerivation rec {
  name = "v4l-utils-0.9.3";

  src = fetchurl {
    url = "http://linuxtv.org/downloads/v4l-utils/${name}.tar.bz2";
    sha256 = "0gaag38x47wlvmp4j60wgf9ma1rxzfyg7i12zxxxi4m3cpcb0bah";
  };

  buildInputs = [ libjpeg which ] ++ stdenv.lib.optional withQt4 qt4;

  # The keytable wants to touch /etc files and udev scripts in /lib.
  # I skip it.
  patchPhase = ''
    sed -i s/keytable// utils/Makefile.in
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = {
    homepage = http://linuxtv.org/projects.php;
    description = "V4L utils and libv4l, that provides common image formats regardless of the v4l device";
    # (The libs are of LGPLv2.1+, some other pieces are GPL)
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
