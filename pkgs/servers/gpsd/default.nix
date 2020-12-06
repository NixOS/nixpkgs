{ stdenv, lib ,fetchurl, scons, pkg-config, dbus, ncurses
, libusb1, docbook_xml_dtd_412, docbook_xsl, bc

# optional deps for GUI packages
, guiSupport ? true
, dbus-glib ? null, libX11 ? null, libXt ? null, libXpm ? null, libXaw ? null, libXext ? null
, gobject-introspection ? null, pango ? null, gdk-pixbuf ? null, atk ? null, wrapGAppsHook ? null

, libxslt, xmlto, gpsdUser ? "gpsd", gpsdGroup ? "dialout"
, pps-tools
, python3Packages
}:


stdenv.mkDerivation rec {
  pname = "gpsd";
  version = "3.21";

  src = fetchurl {
    url = "https://download-mirror.savannah.gnu.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "14gyqrbrq6jz4y6x59rdpv9d4c3pbn0vh1blq3iwrc6kz0x4ql35";
  };

  nativeBuildInputs = [
    scons pkg-config docbook_xml_dtd_412 docbook_xsl xmlto bc
    python3Packages.python
    python3Packages.wrapPython
  ]
  ++ lib.optionals guiSupport [ wrapGAppsHook gobject-introspection ];

  buildInputs = [
    python3Packages.python dbus ncurses
    libxslt libusb1 pps-tools
  ]
  ++ lib.optionals guiSupport [
    dbus-glib libX11 libXt libXpm libXaw libXext
    gobject-introspection pango gdk-pixbuf atk
  ];

  pythonPath = lib.optionals guiSupport [
    python3Packages.pygobject3
    python3Packages.pycairo
  ];

  patches = [
    ./sconstruct-env-fixes.patch
  ];

  postPatch = ''
    sed -i -e '17i#include <sys/sysmacros.h>' serial.c
  '';

  # - leapfetch=no disables going online at build time to fetch leap-seconds
  #   info. See <gpsd-src>/build.txt for more info.
  preBuild = ''
    patchShebangs .
    sed -e "s|systemd_dir = .*|systemd_dir = '$out/lib/systemd/system'|" -i SConstruct

    sconsFlags+=" udevdir=$out/lib/udev"
    sconsFlags+=" python_libdir=$out/lib/${python3Packages.python.libPrefix}/site-packages"
  '';

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
    ${if guiSupport then "" else "rm $out/bin/xgps*"}
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
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
    homepage = "http://catb.org/gpsd/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor rasendubi ];
  };
}
