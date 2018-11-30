{ stdenv, fetchurl, qtbase, qttools, qmake }:

let inherit (stdenv.lib) getDev; in

stdenv.mkDerivation rec {
  name = "qt5ct-${version}";
  version = "0.36";

  src = fetchurl {
    url = "mirror://sourceforge/qt5ct/${name}.tar.bz2";
    sha256 = "12gfhchp05xn311zsxh41k3anyrscg53r5d06dasyxyk6hpr9hwg";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
  ];

  preConfigure = ''
    qmakeFlags+=" PLUGINDIR=$out/$qtPluginPrefix"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt5 Configuration Tool";
    homepage = https://www.opendesktop.org/content/show.php?content=168066;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ralith ];
  };
}
