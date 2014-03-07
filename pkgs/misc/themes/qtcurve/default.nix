{ stdenv, fetchurl, cmake, gettext, gtk2, kde_workspace, kdelibs, libpthreadstubs, libXdmcp
, libxcb, pkgconfig, xlibs }:

stdenv.mkDerivation {
  name = "qtcurve-1.8.17";
  src = fetchurl {
    url = "https://github.com/QtCurve/qtcurve/archive/1.8.17.tar.gz";
    sha256 = "1ixgill9lfhmcfsk5csk6ww3ljzbvb4x48m73apprv949xgr4wyn";
  };

  buildInputs = [
    cmake
    gettext
    gtk2
    kde_workspace
    kdelibs
    libpthreadstubs
    libXdmcp
    libxcb
    pkgconfig
    xlibs.xcbutilimage
  ];

  patches = [ ./qtcurve-1.8.17-install-paths.patch ];

  cmakeFlags = ''
    -DENABLE_QT5=OFF
    -DQTC_QT4_ENABLE_KWIN=ON
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/QtCurve/qtcurve;
    description = "Widget styles for Qt4/KDE4 and gtk2";
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.ttuegel ];
  };
}
