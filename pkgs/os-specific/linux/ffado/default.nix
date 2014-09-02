{ stdenv, fetchurl, dbus, dbus_cplusplus, expat, glibmm, libconfig
, libavc1394, libiec61883, libraw1394, libxmlxx, makeWrapper, pkgconfig
, pyqt4, python, pythonDBus, qt4, scons }:

stdenv.mkDerivation rec {
  name = "libffado-${version}";
  version = "2.2.1";

  src = fetchurl {
    url = "http://www.ffado.org/files/${name}.tgz";
    sha256 = "1ximic90l0av91njb123ra2zp6mg23yg5iz8xa5371cqrn79nacz";
  };

  buildInputs =
    [ dbus dbus_cplusplus expat glibmm libavc1394 libconfig
      libiec61883 libraw1394 libxmlxx makeWrapper pkgconfig pyqt4
      python pythonDBus qt4 scons
    ];

  patches = [ ./enable-mixer-and-dbus.patch ];

  # SConstruct checks cpuinfo and an objdump of /bin/mount to determine the appropriate arch
  # Let's just skip this and tell it which to build
  postPatch = if stdenv.isi686 then ''
    sed '/def is_userspace_32bit(cpuinfo):/a\
        return True' -i SConstruct
  ''
  else ''
    sed '/def is_userspace_32bit(cpuinfo):/a\
        return False' -i SConstruct
  '';

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
