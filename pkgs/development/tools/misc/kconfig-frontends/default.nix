{ lib, stdenv, fetchurl, pkg-config, bison, flex, gperf, ncurses, python3, bash }:

stdenv.mkDerivation rec {
  pname = "kconfig-frontends";
  version = "4.11.0.1";

  src = fetchurl {
    sha256 = "1xircdw3k7aaz29snf96q2fby1cs48bidz5l1kkj0a5gbivw31i3";
    url = "http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-${version}.tar.xz";
  };

  nativeBuildInputs = [ bison flex gperf pkg-config ];
  buildInputs = [ bash ncurses python3 ];

  strictDeps = true;

  configureFlags = [
    "--enable-frontends=conf,mconf,nconf"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=format-security";

  meta = with lib; {
    description = "Out of Linux tree packaging of the kconfig infrastructure";
    longDescription = ''
      Configuration language and system for the Linux kernel and other
      projects. Features simple syntax and grammar, limited yet adequate option
      types, simple organization of options, and direct and reverse
      dependencies.
    '';
    homepage = "http://ymorin.is-a-geek.org/projects/kconfig-frontends";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mbe ];
  };
}
