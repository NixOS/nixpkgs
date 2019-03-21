{ stdenv, fetchFromGitHub
, cmake, extra-cmake-modules, qtquickcontrols, kconfigwidgets, kdeclarative, kdecoration }:

stdenv.mkDerivation rec {
  name = "kdecoration-viewer-2018-07-24";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kdecoration-viewer";
    rev = "6e50b39c651bbf92fd7e7116d43bf57288254288";
    sha256 = "01v6i081vx0mydqvnj05xli86m52v6bxxc3z1zlyyap9cfhag7lj";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ qtquickcontrols kconfigwidgets kdeclarative kdecoration ];

  meta = with stdenv.lib; {
    description = "Allows to preview a KDecoration plugin";
    longDescription = ''
      kdecoration-viewer allows to preview a KDecoration plugin. Put your plugins under
      $QT_PLUGIN_PATH/org.kde.kdecoration2 to preview.
    '';
    homepage = https://blog.martin-graesslin.com/blog/2014/07/kdecoration2-the-road-ahead/;
    license = licenses.gpl2;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
