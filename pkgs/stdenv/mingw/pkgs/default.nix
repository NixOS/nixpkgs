/**
 * MinGW packages.
 */
let {

  /**
   * stdenv and fetchurl are parameters of every function to make this more flexible:
   * after some packages, we might be able to use a better stdenv/fetchurl.
   */
  body = {stdenv, fetchurl} : {
    make = make { inherit stdenv fetchurl; };
    gcc  = gcc  { inherit stdenv fetchurl; };
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
  gcc =  {stdenv, fetchurl} :
    stdenv.mkDerivation {
      name = "mingw-gcc-core-3.4.2-20040916-1";
      builder = ./bin-builder.sh;
      src = 
        fetchurl {
          url = http://surfnet.dl.sourceforge.net/sourceforge/mingw/gcc-core-3.4.2-20040916-1.tar.gz;
          md5 = "d9cd78f926fc31ef101c6fa7072fc65d";
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