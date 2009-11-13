/**
 * MinGW packages.
 */
rec {

  /**
   * Curl, binary
   */
  curl =  {stdenv} :
    stdenv.mkDerivation {
      name = "curl-7.15.4";
      exename = "curl.exe";
      builder = ./single-exe-builder.sh;
      src = ./curl.exe;
    };

  /**
   * Make. Binary.
   */
  make = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-make-3.81";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/mingw32-make-3.81-1.tar.gz;
          md5 = "74c2f44ecc699b318edeb07d838feae5";
        };
    };

  /**
   * GCC. Binary
   */
  gccCore =  {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "gcc-core-3.4.5-mingw32";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/files/GCC%20Version%203/Current%20Release_%20gcc-3.4.5-20060117-3/gcc-core-3.4.5-20060117-3.tar.gz;
          sha256= "1jjj3397fzrly4w0i28mclmawv18g35fak8j8pyr3f34hr1cjwxy";
        };
    };

  /**
   * GCC C++. Binary.
   */
  gccCpp =  {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "gcc-g++-3.4.5-mingw32";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/files/GCC%20Version%203/Current%20Release_%20gcc-3.4.5-20060117-3/gcc-g++-3.4.5-20060117-3.tar.gz;
          sha256 = "022g90p0h2jmfsj03vvni1bw3x9z4lbwchwph39bbm1ilk71a66b";
        };
    };

  /**
   * binutils. Binary.
   */
  binutils =  {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "binutils-2.19.1-mingw32";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/files/GNU%20Binutils/Current%20Release_%20GNU%20binutils-2.19.1/binutils-2.19.1-mingw32-bin.tar.gz;
          sha256 = "037vh2n9iv2vccvplk48vd3al91p7yhc73p5nkfsrb6sg977shj2";
        };
    };

  mingwRuntimeBin = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingwrt-3.16";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/files/MinGW%20Runtime/mingwrt-3.16/mingwrt-3.16-mingw32-dev.tar.gz;
          sha256 = "1xqpp7lvsj88grs6jlk0fnlkvis2y4avcqrpwsaxxrpjlg5bwzci";
        };
    };

  mingwRuntimeSrc = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingwrt-3.16-mingw32";
      builder = ./src-builder.sh;
      src =
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/files/MinGW%20Runtime/mingwrt-3.16/mingwrt-3.16-mingw32-src.tar.gz;
          sha256 = "0rljw3v94z9wzfa63b7lvyprms5l5jgf11lws8vm8z7x7q7h1k38";
        };
    };

  w32apiBin = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "w32api-3.13-mingw32";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/files/MinGW%20API%20for%20MS-Windows/Current%20Release_%20w32api-3.13/w32api-3.13-mingw32-dev.tar.gz;
          sha256 = "19jm2hdym5ixi9b874xmmilixlpxvfdpi5y3bx0bs88fdah03gvx";
        };
    };

  w32apiSrc = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "w32api-3.13-mingw32";
      builder = ./src-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/files/MinGW%20API%20for%20MS-Windows/Current%20Release_%20w32api-3.13/w32api-3.13-mingw32-src.tar.gz;
          sha256 = "1i1gpwilfc21s3yr4sx39i0w4g7lbij427wwxa34gjfgz0awdkh2";
        };
    };

  /**
   * We need a binary pkg-config to bootstrap the compilation of
   * glib and pkg-config: pkg-config needs glib, glib needs pkg-config.
   *
   * This tarball contains pkg-config and all its dependencies. Once we
   * have bootstrapped pkg-config we really need to use a statically linked
   * pkg-config (and provide this .exe at the web: it is really missing
   * on the web).
   */
  pkgconfigBin =  {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "pkgconfig-0.20";
      builder = ./pkgconfig-builder.sh;
      setupHook = ../../../development/tools/misc/pkgconfig/setup-hook.sh;
      src =
        fetchurl {
          url = http://www.cs.uu.nl/people/martin/pkg-config-0.20-bin.tar.gz;
          md5 = "71f9595a022619b8e8b0f7853790c4c7";
        };
    };

  replace = {stdenv, fetchurl} :
    import ../../../tools/text/replace {
      inherit fetchurl stdenv;
    };

  /*
  pkgs.coreutils
  pkgs.findutils
  pkgs.diffutils
  pkgs.gnused
  pkgs.gnugrep
  pkgs.gawk
  pkgs.gnutar
  pkgs.gzip
  pkgs.bzip2
  pkgs.gnumake
  pkgs.bash
  pkgs.patch
  */
}
