{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, glib, syslogng
, eventlog, perl, python, yacc, riemann_c_client, libivykis, protobufc }:

stdenv.mkDerivation rec {
  name = "syslog-ng-incubator-${version}";

  version = "0.3.3";

  src = fetchurl {
    url = "https://github.com/balabit/syslog-ng-incubator/archive/${name}.tar.gz";
    sha256 = "1yx2gdq1vhrcp113hxgl66z5df4ya9nznvq00nvy4v9yn8wf9fb8";
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
