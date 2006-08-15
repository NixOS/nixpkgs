/**
 * Initial stdenv should have:
 * - shell
 * - mkdir
 * - gnu tar
 * - curl
 */
{system} :

let {
  /**
   * Initial standard environment based on native cygwin tools.
   */
  stdenvInit1 =
    import ./simple-stdenv {
      inherit system;
      name = "stdenv-initial-cygwin";
      shell = "/bin/bash.exe";
      path = ["/usr/bin" "/bin"];
    };

  /**
   * Initial standard environment based on MSYS tools.
   * From this point, Cygwin should no longer by involved.
   */
  stdenvInit2 =
    import ./simple-stdenv {
      inherit system;
      name = "stdenv-initial-msys";
      shell = msys + /bin/sh.exe;
      path = [(msys + /bin)];
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

  /**
   * Complete standard environment, based on generic stdenv.
   * It would be better to make the generic stdenv usable on
   * MINGW (i.e. make all environment variables CAPS).
   */
  body =
    let {
      body =
        stdenv // mkDerivationFun;

      shell = msys + /bin/sh + ".exe";

      stdenv =
        stdenvInit2.mkDerivation {
          name = "stdenv-mingw";
          builder = ./builder.sh;
          substitute = ../../build-support/substitute/substitute.sh;
          setup = ./setup.sh;
          initialPath = [msys];
          inherit shell;
          gcc = msys; # TODO
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
