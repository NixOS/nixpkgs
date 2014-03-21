{ fetchurl, stdenv, scons, pythonFull, pkgconfig, dbus, dbus_glib
, ncurses, libX11, libXt, libXpm, libXaw, libXext, makeWrapper
, libusb1, docbook_xml_dtd_412, docbook_xsl, bc
, libxslt, xmlto, gpsdUser ? "gpsd", gpsdGroup ? "dialout"
}:

# TODO: the 'xgps' program doesn't work: "ImportError: No module named gobject"
# TODO: put the X11 deps behind a guiSupport parameter for headless support

stdenv.mkDerivation rec {
  name = "gpsd-3.10";

  src = fetchurl {
    url = "http://download-mirror.savannah.gnu.org/releases/gpsd/${name}.tar.gz";
    sha256 = "0823hl5zgwnbgm0fq3i4z34lv76cpj0k6m0zjiygiyrxrz0w4vvh";
  };

  nativeBuildInputs = [
    scons makeWrapper pkgconfig docbook_xml_dtd_412 docbook_xsl xmlto bc
    pythonFull
  ];

  buildInputs = [
    pythonFull dbus dbus_glib ncurses libX11 libXt libXpm libXaw libXext
    libxslt libusb1
  ];

  patches = [
    ./0001-Import-LD_LIBRARY_PATH-to-allow-running-scons-check-.patch
    ./0002-Import-XML_CATALOG_FILES-to-be-able-to-validate-the-.patch
  ];

  # - leapfetch=no disables going online at build time to fetch leap-seconds
  #   info. See <gpsd-src>/build.txt for more info.
  # - chrpath=no stops the build from using 'chrpath' (which we don't have).
  #   'chrpath' is used to be able to run the tests from the source tree, but
  #   we use $LD_LIBRARY_PATH instead.
  buildPhase = ''
    patchShebangs .
    mkdir -p "$out"
    sed -e "s|python_lib_dir = .*|python_lib_dir = \"$out/lib/${pythonFull.python.libPrefix}/site-packages\"|" -i SConstruct
    scons prefix="$out" leapfetch=no gpsd_user=${gpsdUser} gpsd_group=${gpsdGroup} \
        systemd=yes udevdir="$out/lib/udev" chrpath=no
  '';

  doCheck = true;

  checkPhase = ''
    export LD_LIBRARY_PATH="$PWD"
    scons check
  '';

  # TODO: the udev rules file and the hotplug script need fixes to work on NixOS
  installPhase = ''
    scons install
    mkdir -p "$out/lib/udev/rules.d"
    scons udev-install
  '';

  postInstall = "wrapPythonPrograms";

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
    maintainers = [ maintainers.bjornfor ];
  };
}
