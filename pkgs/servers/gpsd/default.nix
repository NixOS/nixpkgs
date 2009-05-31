{ fetchurl, stdenv, python, pkgconfig, dbus, dbus_glib
, ncurses, libXt, libXpm, libxslt, xmlto, gpsdUser ? "gpsd" }:

stdenv.mkDerivation rec {
  name = "gpsd-2.39";

  src = fetchurl {
    url = "http://download.berlios.de/gpsd/${name}.tar.gz";
    sha256 = "089ahf97dhws3sk8nc88687h4ny2rlavkzg4wxqkhb0i0fs2yfzf";
  };

  buildInputs = [
    python pkgconfig dbus dbus_glib ncurses libXt libXpm
    libxslt xmlto
  ];

  configureFlags = "--enable-dbus --enable-gpsd-user=${gpsdUser}";

  doCheck = true;

  meta = {
    description = "`gpsd', a GPS service daemon";

    longDescription = ''
      gpsd is a service daemon that monitors one or more GPSes
      attached to a host computer through serial or USB ports, making
      all data on the location/course/velocity of the sensors
      available to be queried on TCP port 2947 of the host computer.
      With gpsd, multiple GPS client applications (such as
      navigational and wardriving software) can share access to GPSes
      without contention or loss of data.  Also, gpsd responds to
      queries with a format that is substantially easier to parse than
      the NMEA 0183 emitted by most GPSes.  The gpsd distribution
      includes a linkable C service library, a C++ wrapper class, and
      a Python module that developers of gpsd-aware applications can
      use to encapsulate all communication with gpsd.

      Besides gpsd itself, the project provides auxiliary tools for
      diagnostic monitoring and profiling of GPSes and feeding
      GPS-aware applications GPS logs for diagnostic purposes.
    '';

    homepage = http://gpsd.berlios.de/;

    license = "BSD-style";
  };
}
