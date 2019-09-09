{ mkDerivation, lib, fetchurl, qtbase, qttools, qmake }:

let inherit (lib) getDev; in

mkDerivation rec {
  pname = "qt5ct";
  version = "0.39";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "069y6c17gfics8rz3rdsn2x2hb39m4qka08ygwpxa8gqppffqs9p";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  # Wayland needs to know the desktop file name in order to show the app name and icon.
  # Patch has been upstreamed and can be removed in the future.
  # See: https://sourceforge.net/p/qt5ct/code/549/
  patches = [ ./wayland.patch ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
  ];

  preConfigure = ''
    qmakeFlags+=" PLUGINDIR=$out/$qtPluginPrefix"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Qt5 Configuration Tool";
    homepage = https://www.opendesktop.org/content/show.php?content=168066;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ralith ];
  };
}
