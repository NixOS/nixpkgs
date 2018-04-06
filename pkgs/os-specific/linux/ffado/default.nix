{ stdenv, fetchurl, scons, pkgconfig, which, makeWrapper, python
, expat, libraw1394, libconfig, libavc1394, libiec61883, libxmlxx
, alsaLib, dbus, dbus_cplusplus

# Optional dependencies
, pyqt4 ? null, dbus-python ? null, xdg_utils ? null

# Other Flags
, libOnly ? false
}:

let

  shouldUsePkg = pkg: if pkg != null && pkg.meta.available then pkg else null;

# Mixer/tools dependencies
# FIXME: can we build mixer separately? Then we can farewell `libOnly` mode
# (otherwise we have perfect loop via qt -> pulseaudio -> jack -> ffado -> qt)
# FIXME: it should work with pyqt5 as well (so we can farewell `qt4` sometimes)
  optPyqt4 = shouldUsePkg pyqt4;
  optPythonDBus = shouldUsePkg dbus-python;
  optXdg_utils = shouldUsePkg xdg_utils;

  PYDIR="$out/lib/${python.libPrefix}/site-packages";
  SCONS_OPTIONS = ''
      PREFIX=$out \
      PYPKGDIR=${PYDIR} \
      DEBUG=False \
      ENABLE_ALL=True \
      SERIALIZE_USE_EXPAT=True \
      BUILD_TESTS=False \
      UDEVDIR=$out/lib/udev/rules.d \
      BINDIR=$bin/bin \
      INCLUDEDIR=$dev/include \
      BUILD_MIXER=${if libOnly then "False" else "True"} \
  '';
in
stdenv.mkDerivation rec {
  name = "ffado-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "http://www.ffado.org/files/libffado-${version}.tgz";
    sha256 = "14rprlcd0gpvg9kljh0zzjzd2rc9hbqqpjidshxxjvvfh4r00f4f";
  };

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [ scons pkgconfig which makeWrapper python ];

  buildInputs = [
    expat libraw1394 libconfig libavc1394 libiec61883 dbus dbus_cplusplus libxmlxx
  ] ++ stdenv.lib.optionals (!libOnly) [
    optXdg_utils
  ];

  postPatch = ''
    sed '1iimport sys' -i SConstruct
    # SConstruct checks cpuinfo and an objdump of /bin/mount to determine the appropriate arch
    # Let's just skip this and tell it which to build
    sed '/def is_userspace_32bit(cpuinfo):/a\
        return ${if stdenv.is64bit then "False" else "True"}' -i SConstruct

    # Lots of code is missing random headers to exist
    sed -i '1i #include <memory>' \
      src/ffadodevice.h src/bebob/bebob_dl_mgr.cpp tests/scan-devreg.cpp
    sed -i -e '1i #include <stdlib.h>' \
      -e '1i #include "version.h"' \
      src/libutil/serialize_expat.cpp
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libxml++-2.6)"
  '';

  # TODO fix ffado-diag, it doesn't seem to use PYPKGDIR
  buildPhase = ''
    scons ${SCONS_OPTIONS}
  '';

  installPhase = ''
    scons ${SCONS_OPTIONS} install
  '' + stdenv.lib.optionalString (!libOnly && optPyqt4 != null && optPythonDBus != null) ''
    wrapProgram $out/bin/ffado-mixer --prefix PYTHONPATH : \
      $PYTHONPATH:${PYDIR}:${optPyqt4}/$LIBSUFFIX:${optPythonDBus}/$LIBSUFFIX:

    wrapProgram $out/bin/ffado-diag --prefix PYTHONPATH : \
      $PYTHONPATH:${PYDIR}:$out/share/libffado/python:${optPyqt4}/$LIBSUFFIX:${optPythonDBus}/$LIBSUFFIX:
   '';

  meta = with stdenv.lib; {
    homepage = http://www.ffado.org;
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu wkennington ];
    platforms = platforms.linux;
  };
}
