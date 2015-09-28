{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, gtk2, kde_workspace, kdelibs # Toolkit dependencies
, libpthreadstubs, libXdmcp, libxcb, xorg # X11 dependencies
}:

stdenv.mkDerivation {
  name = "qtcurve-1.8.18";
  src = fetchurl {
    url = "https://github.com/QtCurve/qtcurve/archive/1.8.18.tar.gz";
    sha256 = "19kk11hgi6md1cl0hr0pklcczbl66jczahlkf5fr8j59ljgpr6c5";
  };

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];

  buildInputs = [
    gtk2
    kde_workspace
    kdelibs
    libpthreadstubs
    libXdmcp
    libxcb
    pkgconfig
    xorg.libxshmfence
  ];

  patches = [
    ./qtcurve-1.8.18-install-paths.patch
    ./qtcurve-1.8.18-toolbar-alpha.patch
  ];

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
