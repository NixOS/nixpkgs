{ stdenv, fetchurl, scons, pkgconfig, which, makeWrapper, python
, expat, libraw1394, libconfig, libavc1394, libiec61883, libxmlxx
, glibmm
, alsaLib, dbus, dbus_cplusplus
, pyqt4, dbus-python
}:

stdenv.mkDerivation rec {
  name = "ffado-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "http://www.ffado.org/files/libffado-${version}.tgz";
    sha256 = "14rprlcd0gpvg9kljh0zzjzd2rc9hbqqpjidshxxjvvfh4r00f4f";
  };

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [ scons pkgconfig which makeWrapper python ];

  prefixKey = "PREFIX=";
  sconsFlags = [
    "DEBUG=False"
    "ENABLE_ALL=True"
    "SERIALIZE_USE_EXPAT=True"
    "BUILD_TESTS=False"
    "WILL_DEAL_WITH_XDG_MYSELF=True"
    "BUILD_MIXER=True"
  ];

  configurePhase = ''
    mkdir -p $out/lib/udev/rules.d $bin/bin $dev/include \
             $out/lib/${python.libPrefix}/site-packages
    sconsFlagsArray+=(UDEVDIR=$out/lib/udev/rules.d)
    sconsFlagsArray+=(PYPKGDIR=$out/lib/${python.libPrefix}/site-packages)
    sconsFlagsArray+=(BINDIR=$bin/bin)
    sconsFlagsArray+=(INCLUDEDIR=$dev/include)
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libxml++-2.6)"
  '';

  buildInputs = [
    expat libraw1394 libconfig libavc1394 libiec61883 dbus dbus_cplusplus
    libxmlxx pyqt4 dbus-python glibmm
  ];

  postPatch = ''
    sed '1iimport sys' -i SConstruct
  '';

  postInstall = ''
    for exe in $bin/bin/ffado-mixer $bin/bin/ffado-diag; do
      wrapProgram $exe \
        --prefix PYTHONPATH : $out/lib/${python.libPrefix}/site-packages \
        --prefix PYTHONPATH : $out/share/libffado/python \
        --prefix PYTHONPATH : ${pyqt4}/lib/${python.libPrefix}/site-packages \
        --prefix PYTHONPATH : ${dbus-python}/lib/${python.libPrefix}/site-packages
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.ffado.org;
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu wkennington ];
    platforms = platforms.linux;
  };
}
