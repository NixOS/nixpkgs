{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, syslogng
, eventlog, perl, python, yacc, protobufc, libivykis
}:

stdenv.mkDerivation rec {
  name = "syslog-ng-incubator-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "balabit";
    repo = "syslog-ng-incubator";
    rev = name;
    sha256 = "00j123ya0xfj1jicaqnk1liffx07mhhf0r406pabxjjj97gy8nlk";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook yacc ];

  buildInputs = [
    glib syslogng eventlog perl python protobufc libivykis
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
    broken = true; # does not work with our new syslog-ng version yet
  };
}
