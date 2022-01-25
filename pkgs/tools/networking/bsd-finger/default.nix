{ lib, stdenv, fetchurl }:

# !!! Duplication: this package is almost exactly the same as `bsd-finger'.

stdenv.mkDerivation rec {
  pname = "bsd-finger";
  version = "0.17";

  src = fetchurl {
    url = "mirror://metalab/system/network/finger/bsd-finger-${version}.tar.gz";
    sha256 = "1yhkiv0in588il7f84k2xiy78g9lv12ll0y7047gazhiimk5v244";
  };

  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  patches = [ ./ubuntu-0.17-9.patch ];

  preBuild = "cd finger";

  preInstall = "mkdir -p $out/man/man1 $out/bin ";

  meta = with lib; {
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
  };
}
