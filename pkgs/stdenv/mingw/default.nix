{system} :

let {
  body =
    stdenvFinal;

  /**
   * Initial standard environment based on native Cygwin tools.
   * GCC is not requires.
   * Required (approx): bash, mkdir, gnu tar, curl.
   */
  stdenvInit1 =
    import ./simple-stdenv {
      inherit system;
      name = "stdenv-init1-mingw";
      shell = "/bin/bash.exe";
      path = ["/usr/bin" "/bin" "/usr/local/bin"];
    };

  /**
   * Initial standard environment based on MSYS tools.
   */
  stdenvInit2 =
    import ./simple-stdenv {
      inherit system;
      name = "stdenv-init2-mingw";
      shell = msysShell;
      path = [(msys + "/bin")];
    };

  /**
   * Initial standard environment with the most basic MinGW packages.
   */
  stdenvInit3 =
    (import ./simple-stdenv) {
      inherit system;
      name = "stdenv-init3-mingw";
      shell = msysShell;
      path = [
        (make + "/bin")
        (binutils + "/bin")
        (gccCore + "/bin")
        (mingwRuntimeBin + "/bin")
        (w32apiBin + "/bin")
        (msys + "/bin")
      ];

      extraEnv = {
        C_INCLUDE_PATH = mingwRuntimeBin + "/include" + ":" + w32apiBin + "/include";
        LIBRARY_PATH = mingwRuntimeBin + "/lib" + ":" + w32apiBin + "/lib";
      };
    };

  /**
   * Final standard environment, based on generic stdenv.
   * It would be better to make the generic stdenv usable on
   * MINGW (i.e. make all environment variables CAPS).
   */
  stdenvFinal =
    let {
      body =
        stdenv // mkDerivationFun // {
          inherit fetchurl;
          pkgconfig = pkgconfigBin;
        };

      shell =
        msys + "/bin/sh.exe";

      stdenv =
        stdenvInit2.mkDerivation {
          name = "stdenv-mingw";
          builder = ./builder.sh;
          setup = ./setup.sh;

          /**
           * binutils is on the path because it contains dlltool, which
           * is invoked on the PATH by some packages.
           */
          initialPath = [make binutils gccCore gccCpp mingwRuntimeSrc w32apiSrc msys];
          gcc = gccCore;
          shell = msysShell;
          inherit curl;
          isDarwin = false;
          isMinGW = true;
        };

      mkDerivationFun = {
        mkDerivation = attrs:
          (derivation (
            (removeAttrs attrs ["meta"])
            //
            {
              builder =
                if attrs ? realBuilder then attrs.realBuilder else shell;
              args =
                if attrs ? args then
                  attrs.args
                 else
                  ["-e"] ++ (
                    if attrs ? builder then
                      [./fix-builder.sh attrs.builder]
                    else
                      [./fix-builder.sh ./default-builder.sh]
                    );
              inherit stdenv system;
              C_INCLUDE_PATH = mingwRuntimeSrc + "/include" + ":" + w32apiSrc + "/include";
              CPLUS_INCLUDE_PATH = mingwRuntimeSrc + "/include" + ":" + w32apiSrc + "/include";
              LIBRARY_PATH = mingwRuntimeSrc + "/lib" + ":" + w32apiSrc + "/lib";
            })
          )
          // { meta = if attrs ? meta then attrs.meta else {}; };
       };
     };

  /**
   * fetchurl
   */
  fetchurlInit1 =
    import ../../build-support/fetchurl {
      stdenv = stdenvInit1;
      curl =
        (import ./pkgs).curl {
          stdenv = stdenvInit1;
        };
    };

  cygpath =
    import ./cygpath {
      stdenv = stdenvInit1;
    };

  /**
   * Hack: we need the cygpath of the Cygwin chmod.
   */
  fetchurl =
    import ./fetchurl {
      stdenv = stdenvInit2;
      curl = curl + "/bin/curl.exe";
      chmod = cygpath "/usr/bin/chmod";
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
        fetchurlInit1 {
          url = ftp://ftp.strategoxt.org/pub/mingw/msys-1.0.11.tar.gz;
          md5 = "85ce547934797019d2d642ec3b53934b";
        };
    };

  msysShell = 
    msys + "/bin/sh.exe";

  /**
   * Binary packages, based on stdenvInit2
   */
  curl =
    (import ./pkgs).curl {
      stdenv = stdenvInit2;
    };

  gccCore =
    (import ./pkgs).gccCore {
      stdenv = stdenvInit2;
      inherit fetchurl;
    };

  gccCpp =
    (import ./pkgs).gccCpp {
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

  mingwRuntimeBin =
    (import ./pkgs).mingwRuntimeBin {
      stdenv = stdenvInit2;
      inherit fetchurl;
    };

  w32apiBin =
    (import ./pkgs).w32apiBin {
      stdenv = stdenvInit2;
      inherit fetchurl;
    };

  pkgconfigBin =
    (import ./pkgs).pkgconfigBin {
      stdenv = stdenvInit3;
      inherit fetchurl;
    };

  /**
   * Source packages, based on stdenvInit3
   */
  mingwRuntimeSrc =
    (import ./pkgs).mingwRuntimeSrc {
      stdenv = stdenvInit3;
      inherit fetchurl;
    };

  w32apiSrc =
    (import ./pkgs).w32apiSrc {
      stdenv = stdenvInit3;
      inherit fetchurl;
    };

  replace =
    (import ./pkgs).replace {
      stdenv = stdenvInit3;
      inherit fetchurl;
    };
}
