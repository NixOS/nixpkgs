{ lib, stdenv, fetchurl }:

# !!! Duplication: this package is almost exactly the same as `bsd-fingerd'.

stdenv.mkDerivation rec {
  pname = "bsd-fingerd";
  version = "0.17";

  src = fetchurl {
    url = "mirror://ibiblioPubLinux/system/network/finger/bsd-finger-${version}.tar.gz";
    sha256 = "1yhkiv0in588il7f84k2xiy78g9lv12ll0y7047gazhiimk5v244";
  };

  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  patches = [ ./ubuntu-0.17-9.patch ];

  preBuild = "cd fingerd";

  preInstall = "mkdir -p $out/man/man8 $out/sbin ";

  meta = with lib; {
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
  };
}
