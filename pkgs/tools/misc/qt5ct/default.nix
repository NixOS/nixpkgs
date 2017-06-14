{ stdenv, fetchurl, qtbase, qtsvg, qttools, qmakeHook, makeQtWrapper }:

stdenv.mkDerivation rec {
  name = "qt5ct-${version}";
  version = "0.33";

  src = fetchurl {
    url = "mirror://sourceforge/qt5ct/qt5ct-${version}.tar.bz2";
    sha256 = "0by0wz40rl9gxvwbd85j0y5xy9mjab1cya96rv48x677v95lhm9f";
  };

  nativeBuildInputs = [ makeQtWrapper qmakeHook qttools ];

  buildInputs = [ qtbase qtsvg ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags PLUGINDIR=$out/lib/qt5/plugins"
  '';

  preFixup = ''
    wrapQtProgram $out/bin/qt5ct
  '';

  meta = with stdenv.lib; {
    description = "Qt5 Configuration Tool";
    homepage = https://www.opendesktop.org/content/show.php?content=168066;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ralith ];
  };
}
