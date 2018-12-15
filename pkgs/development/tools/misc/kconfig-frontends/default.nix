{ stdenv, fetchurl, pkgconfig, bison, flex, gperf, ncurses, pythonPackages }:

stdenv.mkDerivation rec {
  basename = "kconfig-frontends";
  version = "4.11.0.1";
  name = "${basename}-${version}";

  src = fetchurl {
    sha256 = "1xircdw3k7aaz29snf96q2fby1cs48bidz5l1kkj0a5gbivw31i3";
    url = "http://ymorin.is-a-geek.org/download/${basename}/${name}.tar.xz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ bison flex gperf ncurses pythonPackages.python pythonPackages.wrapPython ];

  configureFlags = [
    "--enable-frontends=conf,mconf,nconf"
  ];

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Out of Linux tree packaging of the kconfig infrastructure";
    longDescription = ''
      Configuration language and system for the Linux kernel and other
      projects. Features simple syntax and grammar, limited yet adequate option
      types, simple organization of options, and direct and reverse
      dependencies.
    '';
    homepage = http://ymorin.is-a-geek.org/projects/kconfig-frontends;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mbe ];
  };
}
