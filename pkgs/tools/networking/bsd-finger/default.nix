{ stdenv, fetchurl }:

# !!! Duplication: this package is almost exactly the same as `bsd-finger'.

stdenv.mkDerivation rec {
  name = "bsd-finger-0.17";

  src = fetchurl {
    url = "ftp://ftp.metalab.unc.edu/pub/linux/system/network/finger/${name}.tar.gz";
    sha256 = "1yhkiv0in588il7f84k2xiy78g9lv12ll0y7047gazhiimk5v244";
  };

  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  patches = [ ./ubuntu-0.17-9.patch ];

  preBuild = "cd finger";

  preInstall = '' ensureDir $out/man/man1 $out/bin '';
}
