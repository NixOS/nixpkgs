{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, syslogng
, eventlog, perl, python, yacc, riemann_c_client, libivykis, protobufc
}:

stdenv.mkDerivation rec {
  name = "syslog-ng-incubator-${version}";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "balabit";
    repo = "syslog-ng-incubator";
    rev = name;
    sha256 = "0pswajcw9f651c1jmprbf1mlr6qadiaplyygz5j16vj0d23x4mal";
  };

  buildInputs = [
    autoreconfHook pkgconfig glib syslogng eventlog perl python
    yacc riemann_c_client libivykis protobufc
  ];

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
