{ stdenv, fetchurl, dbus, dbus_cplusplus, expat, glibmm, libconfig
, libavc1394, libiec61883, libraw1394, libxmlxx, makeWrapper, pkgconfig
, pyqt4, python, pythonDBus, qt4, scons }:

stdenv.mkDerivation rec {
  name = "libffado-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "http://www.ffado.org/files/${name}.tgz";
    sha256 = "11cxmy31c19720j2171l735rpg7l8i41icsgqscfd2vkbscfmh6y";
  };

  buildInputs =
    [ dbus dbus_cplusplus expat glibmm libavc1394 libconfig
      libiec61883 libraw1394 libxmlxx makeWrapper pkgconfig pyqt4
      python pythonDBus qt4 scons
    ];

  patches = [ ./enable-mixer-and-dbus.patch ];

  # TODO fix ffado-diag, it doesn't seem to use PYPKGDIR
  buildPhase = ''
    export PYLIBSUFFIX=lib/${python.libPrefix}/site-packages
    scons PYPKGDIR=$out/$PYLIBSUFFIX DEBUG=False
    sed -e "s#/usr/local#$out#" -i support/mixer-qt4/ffado/config.py
    '';

  installPhase = ''
    scons PREFIX=$out LIBDIR=$out/lib SHAREDIR=$out/share/libffado \
      PYPKGDIR=$out/$PYLIBSUFFIX UDEVDIR=$out/lib/udev/rules.d install

    sed -e "s#/usr/local#$out#g" -i $out/bin/ffado-diag

    PYDIR=$out/$PYLIBSUFFIX
    wrapProgram $out/bin/ffado-mixer --prefix PYTHONPATH : \
      $PYTHONPATH:$PYDIR:${pyqt4}/$LIBSUFFIX:${pythonDBus}/$LIBSUFFIX:
    wrapProgram $out/bin/ffado-diag --prefix PYTHONPATH : \
      $PYTHONPATH:$PYDIR:$out/share/libffado/python:${pyqt4}/$LIBSUFFIX:${pythonDBus}/$LIBSUFFIX:
    '';

  meta = with stdenv.lib; {
    homepage = http://www.ffado.org;
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
