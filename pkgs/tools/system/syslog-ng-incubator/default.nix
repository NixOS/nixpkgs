{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, glib, syslogng
, eventlog, perl, python, yacc, riemann_c_client, libivykis, protobufc }:

stdenv.mkDerivation rec {
  name = "syslog-ng-incubator-${version}";

  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/balabit/syslog-ng-incubator/archive/${name}.tar.gz";
    sha256 = "0zr0vlp7cq3qfhqhalf7rdyd54skswxnc9j9wi8sfmz3psy3vd4y";
  };

  buildInputs = [
    autoconf automake libtool pkgconfig glib syslogng eventlog perl python
    yacc riemann_c_client libivykis protobufc
  ];

  preConfigure = "autoreconf -i";

  configureFlags = [
    "--without-ivykis"
    "--with-riemann"
    "--with-module-dir=$(out)/lib/syslog-ng"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/balabit/syslog-ng-incubator";
    description = "A collection of tools and modules for syslog-ng";
    license = licenses.gpl2;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
