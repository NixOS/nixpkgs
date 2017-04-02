{ stdenv, fetchFromGitHub
, cmake, extra-cmake-modules, qtquickcontrols, kconfigwidgets, kdeclarative, kdecoration }:

stdenv.mkDerivation rec {
  name = "kdecoration-viewer-2015-08-20";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kdecoration-viewer";
    rev = "d7174acee01475fbdb71cfd48ca49d487a141701";
    sha256 = "1cc4xxv72a82p1w9r76090xba7g069r41bi4zx32k4gz3vyl1am6";
  };

  buildInputs = [ cmake extra-cmake-modules qtquickcontrols kconfigwidgets kdeclarative kdecoration ];

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
