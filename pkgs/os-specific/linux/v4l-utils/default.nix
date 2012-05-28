{stdenv, fetchurl, which, libjpeg
, withQt4 ? false, qt4 ? null}:

assert withQt4 -> qt4 != null;

stdenv.mkDerivation rec {
  name = "v4l-utils-0.8.8";

  src = fetchurl {
    url = "http://linuxtv.org/downloads/v4l-utils/${name}.tar.bz2";
    sha256 = "0zx8f1npsl6g5vjah1gwydg1j5azl74kr83ifbjhshgmnvscd92z";
  };

  buildInputs = [ libjpeg which ] ++ stdenv.lib.optional withQt4 qt4;

  # The keytable wants to touch /etc files and udev scripts in /lib.
  # I skip it.
  patchPhase = ''
    sed -i s/keytable// utils/Makefile
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
