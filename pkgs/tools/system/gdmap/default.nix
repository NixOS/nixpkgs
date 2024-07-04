{ lib, stdenv, fetchurl, gtk2, pkg-config, libxml2, intltool, gettext }:

stdenv.mkDerivation rec {
  pname = "gdmap";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/gdmap/gdmap-${version}.tar.gz";
    sha256 = "0nr8l88cg19zj585hczj8v73yh21k7j13xivhlzl8jdk0j0cj052";
  };

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ gtk2 libxml2 gettext ];

  patches = [ ./get_sensitive.patch ./set_flags.patch ];

  hardeningDisable = [ "format" ];

  NIX_LDFLAGS = "-lm";

  meta = with lib; {
    homepage = "https://gdmap.sourceforge.net";
    description = "Recursive rectangle map of disk usage";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "gdmap";
  };
}
