{ mkDerivation, lib, fetchurl, qtbase, qtsvg, qttools, qmake }:

let inherit (lib) getDev; in

mkDerivation rec {
  pname = "qt5ct";
<<<<<<< HEAD
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-7VhUam5MUN/tG5/2oUjUpGj+m017WycnuWUB3ilVuNc=";
=======
  version = "1.5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-1j0M4W4CQnIH2GUx9wpxxbnIUARN1bLcsihVMfQW5JA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase qtsvg ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
    "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
<<<<<<< HEAD
    "LIBDIR=${placeholder "out"}/lib"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Qt5 Configuration Tool";
    homepage = "https://www.opendesktop.org/content/show.php?content=168066";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ralith ];
  };
}
