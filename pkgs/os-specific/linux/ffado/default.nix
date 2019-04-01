{ stdenv, fetchurl, scons, pkgconfig, which, makeWrapper, python3
, libraw1394, libconfig, libavc1394, libiec61883, libxmlxx3
, glibmm
, alsaLib, dbus, dbus_cplusplus
}:

let
  inherit (python3.pkgs) pyqt5 dbus-python;
  python = python3.withPackages (pkgs: with pkgs; [ pyqt5 dbus-python ]);
in stdenv.mkDerivation rec {
  pname = "ffado";
  version = "2.4.1";

  src = fetchurl {
    url = "http://www.ffado.org/files/libffado-${version}.tgz";
    sha256 = "0byr3kv58d1ryy60vr69fd868zlfkvl2gq9hl94dqdn485l9pq9y";
  };

  patches = [
    # fix installing metainfo file
    ./fix-build.patch
  ];

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [ scons pkgconfig which makeWrapper python pyqt5 ];

  prefixKey = "PREFIX=";
  sconsFlags = [
    "DEBUG=False"
    "ENABLE_ALL=True"
    "BUILD_TESTS=False"
    "WILL_DEAL_WITH_XDG_MYSELF=True"
    "BUILD_MIXER=True"
    "UDEVDIR=${placeholder "out"}/lib/udev/rules.d"
    "PYPKGDIR=${placeholder "out"}/${python3.sitePackages}"
    "BINDIR=${placeholder "bin"}/bin"
    "INCLUDEDIR=${placeholder "dev"}/include"
    "PYTHON_INTERPRETER=${python.interpreter}"
  ];

  buildInputs = [
    libraw1394
    libconfig
    libavc1394
    libiec61883
    dbus
    dbus_cplusplus
    libxmlxx3
    python
    glibmm
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.ffado.org;
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
