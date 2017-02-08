{ stdenv, fetchurl, pkgconfig, glib, syslogng
, eventlog, perl, python, yacc, riemann_c_client, libivykis, protobufc
}:

stdenv.mkDerivation rec {
  name = "syslog-ng-incubator-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/balabit/syslog-ng-incubator/releases/download/${name}/${name}.tar.xz";
    sha256 = "1was8g3ckghs6fb7zz6dlp506m65cfi6l7iyj0wp5cqc9cff05gk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    glib syslogng eventlog /* perl */ python
    yacc riemann_c_client libivykis protobufc
  ];

  configureFlags = [
    "--with-module-dir=$(out)/lib/syslog-ng"
    "--disable-perl" # fails to build
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/balabit/syslog-ng-incubator";
    description = "A collection of tools and modules for syslog-ng";
    license = licenses.gpl2;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
