{ mkDerivation, lib, fetchurl, qtbase, qtsvg, qttools, qmake }:

let inherit (lib) getDev; in

mkDerivation rec {
  pname = "qt5ct";
  version = "1.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1lnx4wqk87lbr6lqc64w5g5ppjjv75kq2r0q0bz9gfpryzdw8xxg";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase qtsvg ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
    "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Qt5 Configuration Tool";
    homepage = "https://www.opendesktop.org/content/show.php?content=168066";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ralith ];
  };
}
