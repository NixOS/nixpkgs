{ stdenv, fetchurl, scons, pkgconfig, which, makeWrapper, python
, expat, libraw1394, libconfig, libavc1394, libiec61883

# Optional dependencies
, libjack2 ? null, dbus ? null, dbus_cplusplus ? null, alsaLib ? null
, pyqt4 ? null, dbus-python ? null, xdg_utils ? null

# Other Flags
, prefix ? ""
}:

let

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  libOnly = prefix == "lib";

  optLibjack2 = shouldUsePkg libjack2;
  optDbus = shouldUsePkg dbus;
  optDbus_cplusplus = shouldUsePkg dbus_cplusplus;
  optAlsaLib = shouldUsePkg alsaLib;
  optPyqt4 = shouldUsePkg pyqt4;
  optPythonDBus = shouldUsePkg dbus-python;
  optXdg_utils = shouldUsePkg xdg_utils;
in
stdenv.mkDerivation rec {
  name = "${prefix}ffado-${version}";
  version = "2.2.1";

  src = fetchurl {
    url = "http://www.ffado.org/files/libffado-${version}.tgz";
    sha256 = "1ximic90l0av91njb123ra2zp6mg23yg5iz8xa5371cqrn79nacz";
  };

  nativeBuildInputs = [ scons pkgconfig which makeWrapper python ];

  buildInputs = [
    expat libraw1394 libconfig libavc1394 libiec61883
  ] ++ stdenv.lib.optionals (!libOnly) [
    optLibjack2 optDbus optDbus_cplusplus optAlsaLib optPyqt4
    optXdg_utils
  ];

  patches = [ ./build-fix.patch ];

  postPatch = ''
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

  # TODO fix ffado-diag, it doesn't seem to use PYPKGDIR
  buildPhase = ''
    export PYDIR=$out/lib/${python.libPrefix}/site-packages

    scons PYPKGDIR=$PYDIR DEBUG=False \
      ENABLE_ALL=True \
      SERIALIZE_USE_EXPAT=True \
  '';

  installPhase = if libOnly then ''
    scons PREFIX=$TMPDIR UDEVDIR=$TMPDIR \
      LIBDIR=$out/lib INCLUDEDIR=$out/include install
  '' else ''
    scons PREFIX=$out PYPKGDIR=$PYDIR UDEVDIR=$out/lib/udev/rules.d install
  '' + stdenv.lib.optionalString (optPyqt4 != null && optPythonDBus != null) ''
    wrapProgram $out/bin/ffado-mixer --prefix PYTHONPATH : \
      $PYTHONPATH:$PYDIR:${optPyqt4}/$LIBSUFFIX:${optPythonDBus}/$LIBSUFFIX:

    wrapProgram $out/bin/ffado-diag --prefix PYTHONPATH : \
      $PYTHONPATH:$PYDIR:$out/share/libffado/python:${optPyqt4}/$LIBSUFFIX:${optPythonDBus}/$LIBSUFFIX:
  '';

  meta = with stdenv.lib; {
    homepage = http://www.ffado.org;
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu wkennington ];
    platforms = platforms.linux;
  };
}
