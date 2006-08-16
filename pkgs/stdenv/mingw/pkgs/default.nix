/**
 * MinGW packages.
 */
rec {

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
      name = "mingw-gcc-core-3.4.2-20040916-1";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/gcc-core-3.4.2-20040916-1.tar.gz;
          md5 = "d9cd78f926fc31ef101c6fa7072fc65d";
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
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/binutils-2.16.91-20060119-1.tar.gz;
          md5 = "a54f33ca9d6cf56dc99c0c5367f58ea3";
        };
    };

  mingwRuntimeBin = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-runtime-3.10";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/mingw-runtime-3.10.tar.gz;
          md5 = "7fa2638d23136fd84d5d627bef3b408a";
        };
    };

  mingwRuntimeSrc = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-runtime-3.10";
      builder = ./src-builder.sh;
      src =
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/mingw-runtime-3.10-src.tar.gz;
          md5 = "9225684e663eafa900b4075731c25f4c";
        };
    };

  w32apiBin = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "w32api-3.7";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/w32api-3.7.tar.gz;
          md5 = "0b3a6d08136581c93b3a3207588acea9";
        };
    };

  w32apiSrc = {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "w32api-3.7";
      builder = ./src-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/w32api-3.7-src.tar.gz;
          md5 = "d799c407b4c1b480d0339994d01f355d";
        };
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