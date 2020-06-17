{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, syslogng
, eventlog, perl, python, yacc, protobufc, libivykis, libcap, czmq
}:

stdenv.mkDerivation rec {
  pname = "syslog-ng-incubator";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "balabit";
    repo = "syslog-ng-incubator";
    rev = "${pname}-${version}";
    sha256 = "17y85cqcyfbp882gaii731cvz5bg1s8rgda271jh6kgnrz5rbd4s";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook yacc ];

  buildInputs = [
    glib syslogng eventlog perl python protobufc libivykis libcap czmq
  ];

  configureFlags = [
    "--with-module-dir=$(out)/lib/syslog-ng"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/balabit/syslog-ng-incubator";
    description = "A collection of tools and modules for syslog-ng";
    license = licenses.gpl2;
    maintainers = [];
    platforms = platforms.linux;
    broken = true; # 2018-05-12
  };
}
