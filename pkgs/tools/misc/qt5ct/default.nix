{stdenv, fetchurl, qtbase, qtsvg, qttools, qmakeHook, makeQtWrapper}:

stdenv.mkDerivation rec {
  name = "qt5ct-${version}";
  version = "0.24";

  src = fetchurl {
    url = "mirror://sourceforge/qt5ct/qt5ct-${version}.tar.bz2";
    sha256 = "0k62nd945pbgkshycijzrgdyrwj5kcswk33slaj7hr7d6r7bmb6p";
  };

  buildInputs = [ qtbase qtsvg ];
  nativeBuildInputs = [ makeQtWrapper qmakeHook qttools ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags PLUGINDIR=$out/lib/qt5/plugins/platformthemes/"
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
