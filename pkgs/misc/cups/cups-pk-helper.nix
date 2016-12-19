{ stdenv, fetchurl, intltool, pkgconfig, glib, polkit, cups }:

stdenv.mkDerivation rec {
  version = "0.2.5";
  name = "cups-pk-helper-${version}";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-${version}.tar.xz";
    sha256 = "0651ij5p5s0n3xxbaqsy72s22nx9hfkrjgvg766lkqd1cpniw8hr";
  };

  buildInputs = [ intltool pkgconfig glib polkit cups ];

  meta = with stdenv.lib; {
    description = "PolicyKit helper to configure cups with fine-grained privileges";
    homepage = http://www.freedesktop.org/wiki/Software/cups-pk-helper/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
