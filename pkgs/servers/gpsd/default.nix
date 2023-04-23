{ stdenv
, lib
, fetchurl

# nativeBuildInputs
, scons
, pkg-config

# buildInputs
, dbus
, libusb1
, ncurses
, pps-tools
, python3Packages

# optional deps for GUI packages
, guiSupport ? true
, dbus-glib
, libX11
, libXt
, libXpm
, libXaw
, libXext
, gobject-introspection
, pango
, gdk-pixbuf
, atk
, wrapGAppsHook

, gpsdUser ? "gpsd", gpsdGroup ? "dialout"
}:

stdenv.mkDerivation rec {
  pname = "gpsd";
  version = "3.25";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-s2i2owXj96Y4LSOgy/wdeJIwYLa39Uz3mHpzx7Spr8I=";
  };

  # TODO: render & install HTML documentation using asciidoctor
  nativeBuildInputs = [
    pkg-config
    python3Packages.wrapPython
    scons
  ] ++ lib.optionals guiSupport [
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    libusb1
    ncurses
    pps-tools
    python3Packages.python
  ] ++ lib.optionals guiSupport [
    atk
    dbus-glib
    gdk-pixbuf
    libX11
    libXaw
    libXext
    libXpm
    libXt
    pango
  ];

  pythonPath = lib.optionals guiSupport [
    python3Packages.pygobject3
    python3Packages.pycairo
  ];

  patches = [
    ./sconstruct-env-fixes.patch
  ];

  preBuild = ''
    patchShebangs .
    sed -e "s|systemd_dir = .*|systemd_dir = '$out/lib/systemd/system'|" -i SConscript
    export TAR=noop
    substituteInPlace SConscript --replace "env['CCVERSION']" "env['CC']"

    sconsFlags+=" udevdir=$out/lib/udev"
    sconsFlags+=" python_libdir=$out/lib/${python3Packages.python.libPrefix}/site-packages"
  '';

  # - leapfetch=no disables going online at build time to fetch leap-seconds
  #   info. See <gpsd-src>/build.txt for more info.
  sconsFlags = [
    "leapfetch=no"
    "gpsd_user=${gpsdUser}"
    "gpsd_group=${gpsdGroup}"
    "systemd=yes"
    "xgps=${if guiSupport then "True" else "False"}"
  ];

  preCheck = ''
    export LD_LIBRARY_PATH="$PWD"
  '';

  # TODO: the udev rules file and the hotplug script need fixes to work on NixOS
  preInstall = ''
    mkdir -p "$out/lib/udev/rules.d"
  '';

  installTargets = [ "install" "udev-install" ];

  # remove binaries for x-less install because xgps sconsflag is partially broken
  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with lib; {
    description = "GPS service daemon";
    longDescription = ''
      gpsd is a service daemon that monitors one or more GPSes or AIS
      receivers attached to a host computer through serial or USB ports,
      making all data on the location/course/velocity of the sensors
      available to be queried on TCP port 2947 of the host computer. With
      gpsd, multiple location-aware client applications (such as navigational
      and wardriving software) can share access to receivers without
      contention or loss of data. Also, gpsd responds to queries with a
      format that is substantially easier to parse than the NMEA 0183 emitted
      by most GPSes. The gpsd distribution includes a linkable C service
      library, a C++ wrapper class, and a Python module that developers of
      gpsd-aware applications can use to encapsulate all communication with
      gpsd. Third-party client bindings for Java and Perl also exist.

      Besides gpsd itself, the project provides auxiliary tools for
      diagnostic monitoring and profiling of receivers and feeding
      location-aware applications GPS/AIS logs for diagnostic purposes.
    '';
    homepage = "https://gpsd.gitlab.io/gpsd/index.html";
    changelog = "https://gitlab.com/gpsd/gpsd/-/blob/release-${version}/NEWS";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor rasendubi ];
  };
}
