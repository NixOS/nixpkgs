{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, syslogng
, eventlog, perl, python, yacc, riemann_c_client, libivykis, protobufc
}:

stdenv.mkDerivation rec {
  name = "syslog-ng-incubator-${version}";
  version = "141106-54179c5";

  src = fetchFromGitHub {
    owner = "balabit";
    repo = "syslog-ng-incubator";
    rev = "54179c5f733487fe97ee856bc27130d0b09f3d5a";
    sha256 = "1y099f7pdan1441ycycd67igcwbla2m2cgnxjfvdw76llvi35sam";
  };

  buildInputs = [
    autoreconfHook pkgconfig glib syslogng eventlog perl python
    yacc riemann_c_client libivykis protobufc
  ];

  configureFlags = [
    "--without-ivykis"
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
