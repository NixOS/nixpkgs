/**
 * Initial stdenv should have:
 * - shell
 * - mkdir
 * - gnu tar
 * - curl
 */
{system} :

let {
  body =
    stdenvFinal;

  /**
   * Initial standard environment based on native Cygwin tools.
   */
  stdenvInit1 =
    import ./simple-stdenv {
      inherit system;
      name = "stdenv-init1-mingw";
      shell = "/bin/bash.exe";
      path = ["/usr/bin" "/bin"];
    };

  /**
   * Initial standard environment based on MSYS tools.
   */
  stdenvInit2 =
    import ./simple-stdenv {
      inherit system;
      name = "stdenv-init2-mingw";
      shell = msysShell;
      path = [(msys + /bin)];
    };

  /**
   * Initial standard environment with the most basic MinGW packages.
   */
  stdenvInit3 =
    (import ./simple-stdenv) {
      inherit system;
      name = "stdenv-init3-mingw";
      shell = msysShell;
      path = [ (make + /bin) (msys + /bin) (binutils /bin) (gccCore + /bin) ];
    };

  /**
   * Final standard environment, based on generic stdenv.
   * It would be better to make the generic stdenv usable on
   * MINGW (i.e. make all environment variables CAPS).
   */
  stdenvFinal =
    let {
      body =
        stdenv // mkDerivationFun;

      shell =
        msys + /bin/sh + ".exe";

      gccWrapper = (import ../../build-support/gcc-wrapper) {
        name = "mingw-gcc-wrapper";
        nativeTools = false;
        nativeGlibc = true;
        shell = msysShell;
        binutils = binutils;
        gcc = gccCore // { langC = true; langCC = false; langF77 = false; };

        /**
         * Tricky: gcc-wrapper cannot be constructed using the MSYS shell
         * so we use the Cygwin shell.
         */
        stdenv = stdenvInit1;
      };

      stdenv =
        stdenvInit2.mkDerivation {
          name = "stdenv-mingw";
          builder = ./builder.sh;
          substitute = ../../build-support/substitute/substitute.sh;
          setup = ./setup.sh;
          initialPath = [make msys];
          gcc = gccWrapper;
          shell = msysShell;
        };

      mkDerivationFun = {
        mkDerivation = attrs:
          (derivation (
            (removeAttrs attrs ["meta"])
            //
            {
              builder = if attrs ? realBuilder then attrs.realBuilder else shell;
              args = if attrs ? args then attrs.args else
                ["-e" (if attrs ? builder then attrs.builder else ../generic/default-builder.sh)];
              inherit stdenv system;
            })
          )
          // { meta = if attrs ? meta then attrs.meta else {}; };
       };
     };


  /**
   * Fetchurl, based on Cygwin curl in stdenvInit1
   */
  fetchurl =
    import ../../build-support/fetchurl {
      stdenv = stdenvInit1;

      /**
       * use native curl in Cygwin. We could consider to use curl.exe,
       * which is widely available (or we could bootstrap it ourselves)
       */
      curl = null;
    };

  /**
   * MSYS, installed using stdenvInit1
   *
   * @todo Maybe remove the make of msys?
   */
  msys =
    stdenvInit1.mkDerivation {
      name = "msys-1.0.11";
      builder = ./msys-builder.sh;
      src =
        fetchurl {
          url = http://www.cs.uu.nl/people/martin/msys-1.0.11.tar.gz;
          md5 = "85ce547934797019d2d642ec3b53934b";
        };
    };

  msysShell = 
    msys + /bin/sh + ".exe";

  gccCore =
    (import ./pkgs).gccCore {
      stdenv = stdenvInit2;
      inherit fetchurl;
    };

  make =
   (import ./pkgs).make {
     stdenv = stdenvInit2;
     inherit fetchurl;
   };

  binutils =
   (import ./pkgs).binutils {
     stdenv = stdenvInit2;
     inherit fetchurl;
    };
}

     /* 

  mingw = {
    langC = true;
    langCC = true;
    langF77 = true;
  };

    gcc =
      import ../../build-support/gcc-wrapper {
        nativeTools = false;
        nativeGlibc = false;
        stdenv = stdenvInitial;
        binutils = msys;
        gcc = mingw;
        shell = msys + /bin/sh;
      }; */
