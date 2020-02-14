{ fetchurl, stdenv, scons, pkgconfig, dbus, dbus-glib
, ncurses, libX11, libXt, libXpm, libXaw, libXext
, libusb1, docbook_xml_dtd_412, docbook_xsl, bc
, libxslt, xmlto, gpsdUser ? "gpsd", gpsdGroup ? "dialout"
, pps-tools
, python2Packages
}:

# TODO: put the X11 deps behind a guiSupport parameter for headless support

stdenv.mkDerivation rec {
  name = "gpsd-3.16";

  src = fetchurl {
    url = "https://download-mirror.savannah.gnu.org/releases/gpsd/${name}.tar.gz";
    sha256 = "0a90ph4qrlz5kkcz2mwkfk3cmwy9fmglp94znz2y0gsd7bqrlmq3";
  };

  nativeBuildInputs = [
    scons pkgconfig docbook_xml_dtd_412 docbook_xsl xmlto bc
    python2Packages.python
    python2Packages.wrapPython
  ];

  buildInputs = [
    python2Packages.python dbus dbus-glib ncurses libX11 libXt libXpm libXaw libXext
    libxslt libusb1 pps-tools
  ];

  pythonPath = [
    python2Packages.pygobject2
    python2Packages.pygtk
  ];

  patches = [
    ./0001-Import-LD_LIBRARY_PATH-to-allow-running-scons-check-.patch
    ./0002-Import-XML_CATALOG_FILES-to-be-able-to-validate-the-.patch

    # TODO: remove the patch with the next release
    ./0001-Use-pkgconfig-for-dbus-library.patch
    # to be able to find pps-tools
    ./0002-scons-envs-patch.patch
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
    sconsFlags+=" python_libdir=$out/lib/${python2Packages.python.libPrefix}/site-packages"
  '';

  sconsFlags = [
    "leapfetch=no"
    "gpsd_user=${gpsdUser}"
    "gpsd_group=${gpsdGroup}"
    "systemd=yes"
  ];

  preCheck = ''
    export LD_LIBRARY_PATH="$PWD"
  '';

  # TODO: the udev rules file and the hotplug script need fixes to work on NixOS
  preInstall = ''
    mkdir -p "$out/lib/udev/rules.d"
  '';
  installTargets = [ "install" "udev-install" ];

  postFixup = ''
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
    homepage = http://catb.org/gpsd/;
    license = "BSD-style";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor rasendubi ];
  };
}
