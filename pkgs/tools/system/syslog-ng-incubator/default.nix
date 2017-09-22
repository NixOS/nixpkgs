{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, syslogng
, eventlog, perl, python, yacc, protobufc, libivykis, libcap, czmq
}:

stdenv.mkDerivation rec {
  name = "syslog-ng-incubator-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "balabit";
    repo = "syslog-ng-incubator";
    rev = name;
    sha256 = "1wiv289lc5kxsd3ydyn1zvvgjrj1mv2jghv0cm425wsdsfr7fjb0";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook yacc ];

  buildInputs = [
    glib syslogng eventlog perl python protobufc libivykis libcap czmq
  ];

  configureFlags = [
    "--with-module-dir=$(out)/lib/syslog-ng"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/balabit/syslog-ng-incubator;
    description = "A collection of tools and modules for syslog-ng";
    license = licenses.gpl2;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
