{ stdenv, fetchurl, scons, pkgconfig, which, makeWrapper, python
, expat, libraw1394, libconfig, libavc1394, libiec61883, libxmlxx
, alsaLib, dbus, dbus_cplusplus

# Optional dependencies
, pyqt4 ? null, dbus-python ? null

# ffado contain two (actually) independed packages core libraries and mixer,
# each of them have completely independed set of dependencies, and mixer even
# not use libraries for core packages. So `mixerOnly` parameter change logic of
# these expression, patching out all-but-mixer. Otherwise we have perfect build loop
# (via ffado -> pyqt4 -> qt4 -> pulseaudio -> ffado)
, mixerOnly ? false
}:

let
  PYDIR="$out/lib/${python.libPrefix}/site-packages";
  BINDIR = if mixerOnly then "$out/bin" else "$bin/bin";
  SCONS_OPTIONS = ''
      PREFIX=$out \
      PYPKGDIR=${PYDIR} \
      DEBUG=False \
      ENABLE_ALL=True \
      SERIALIZE_USE_EXPAT=True \
      BUILD_TESTS=False \
      UDEVDIR=$out/lib/udev/rules.d \
      BINDIR=${BINDIR} \
      INCLUDEDIR=$dev/include \
      WILL_DEAL_WITH_XDG_MYSELF=True \
      BUILD_MIXER=${if mixerOnly then "True" else "False"} \
  '';
in
stdenv.mkDerivation rec {
  name = "ffado-${if mixerOnly then "mixer" else "core"}-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "http://www.ffado.org/files/libffado-${version}.tgz";
    sha256 = "14rprlcd0gpvg9kljh0zzjzd2rc9hbqqpjidshxxjvvfh4r00f4f";
  };

  outputs = if mixerOnly then [ "out" ] else [ "out" "bin" "dev" ];

  nativeBuildInputs = [ scons pkgconfig which makeWrapper python ];

  buildInputs = [
    expat libraw1394 libconfig libavc1394 libiec61883 dbus dbus_cplusplus libxmlxx
  ] ++ stdenv.lib.optionals mixerOnly [
    pyqt4 dbus-python
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
  '' + stdenv.lib.optionalString mixerOnly ''
    sed 's!dirs=subdirs!dirs=["support/mixer-qt4"]!' -i SConstruct
    sed "/env.Install/ d" -i SConstruct
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libxml++-2.6)"
  '';

  # TODO fix ffado-diag, it doesn't seem to use PYPKGDIR
  buildPhase = ''
    scons ${SCONS_OPTIONS}
  '';

  installPhase = ''
    scons ${SCONS_OPTIONS} ${if mixerOnly then "${BINDIR} ${PYDIR}" else "install"}
  '' + stdenv.lib.optionalString mixerOnly ''
    wrapProgram $out/bin/ffado-mixer --prefix PYTHONPATH : \
      $PYTHONPATH:${PYDIR}:${pyqt4}/$LIBSUFFIX:${dbus-python}/$LIBSUFFIX:
   '';

  meta = with stdenv.lib; {
    homepage = http://www.ffado.org;
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu wkennington ];
    platforms = platforms.linux;
  };
}
