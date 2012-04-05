{stdenv, fetchsvn, dbus_glib, dbus_libs, expat, glibmm, jackaudio
, libconfig, libiec61883, libraw1394, libxmlxx, pkgconfig, pyqt4, python
, pythonDBus, qt4, scons }:

stdenv.mkDerivation rec {
  name = "libffado-svn";

  src = fetchsvn {
    url = "http://subversion.ffado.org/ffado/trunk/libffado";
    rev = "2117";
    sha256 = "0awv1ccvxxxs5ycd5v3xn79flr79ia8290wmraf0646avihkcpvj";
  };

  buildInputs =
    [ dbus_glib dbus_libs expat glibmm jackaudio libconfig libiec61883
      libraw1394 libxmlxx pkgconfig pyqt4 python pythonDBus qt4 scons
    ];

  buildPhase = "scons";
  installPhase = ''
    scons PREFIX=$out LIBDIR=$out/lib SHAREDIR=$out/share/libffado install
    '';

  meta = with stdenv.lib; {
    homepage = http://www.ffado.org;
    description = "Firewire audio drivers";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
  };
}
