{ mkDerivation, lib, fetchurl, qtbase, qtsvg, qttools, qmake }:

let inherit (lib) getDev; in

mkDerivation rec {
  pname = "qt5ct";
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-7VhUam5MUN/tG5/2oUjUpGj+m017WycnuWUB3ilVuNc=";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase qtsvg ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
    "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  meta = with lib; {
    description = "Qt5 Configuration Tool";
    homepage = "https://www.opendesktop.org/content/show.php?content=168066";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ralith ];
  };
}
