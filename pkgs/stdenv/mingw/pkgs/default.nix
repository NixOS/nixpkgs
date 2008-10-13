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
          url = mirror://sourceforge/mingw/mingw32-make-3.81-1.tar.gz;
          md5 = "74c2f44ecc699b318edeb07d838feae5";
        };
    };

  /**
   * GCC. Binary
   */
  gccCore =  {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-gcc-core-3.4.2-20040916-1";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = mirror://sourceforge/mingw/gcc-core-3.4.2-20040916-1.tar.gz;
          md5 = "d9cd78f926fc31ef101c6fa7072fc65d";
        };
    };

  /**
   * GCC C++. Binary.
   */
  gccCpp =  {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-gcc-g++-3.4.2-20040916-1";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = mirror://sourceforge/mingw/gcc-g++-3.4.2-20040916-1.tar.gz;
          md5 = "e5c7eb2c1e5f7e10842eac03d1d6fcdc";
        };
    };

  /**
   * binutils. Binary.
   */
  binutils =  {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-binutils-2.16.91-20060119-1";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = mirror://sourceforge/mingw/binutils-2.16.91-20060119-1.tar.gz;
          md5 = "a54f33ca9d6cf56dc99c0c5367f58ea3";
        };
    };

  mingwRuntimeBin = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-runtime-3.10";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = mirror://sourceforge/mingw/mingw-runtime-3.10.tar.gz;
          md5 = "7fa2638d23136fd84d5d627bef3b408a";
        };
    };

  mingwRuntimeSrc = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-runtime-3.10";
      builder = ./src-builder.sh;
      src =
        fetchurl {
          url = mirror://sourceforge/mingw/mingw-runtime-3.10-src.tar.gz;
          md5 = "9225684e663eafa900b4075731c25f4c";
        };
    };

  w32apiBin = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "w32api-3.7";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = mirror://sourceforge/mingw/w32api-3.7.tar.gz;
          md5 = "0b3a6d08136581c93b3a3207588acea9";
        };
    };

  w32apiSrc = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "w32api-3.7";
      builder = ./src-builder.sh;
      src = 
        fetchurl {
          url = mirror://sourceforge/mingw/w32api-3.7-src.tar.gz;
          md5 = "d799c407b4c1b480d0339994d01f355d";
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
  pkgs.gnumakeNix
  pkgs.bash
  pkgs.patch
  */
}