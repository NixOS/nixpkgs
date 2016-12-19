{ stdenv, fetchurl, pkgconfig, bison, flex, gperf, ncurses }:

stdenv.mkDerivation rec {
  basename = "kconfig-frontends";
  version = "3.12.0.0";
  name = "${basename}-${version}";

  src = fetchurl {
    sha256 = "01zlph9bq2xzznlpmfpn0zrmhf2iqw02yh1q7g7adgkl5jk1a9pa";
    url = "http://ymorin.is-a-geek.org/download/${basename}/${name}.tar.xz";
  };

  buildInputs = [ bison flex gperf ncurses pkgconfig ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--enable-frontends=conf,mconf,nconf"
  ];

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
