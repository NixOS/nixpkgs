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
      shell = "/bin/bash";
      path = ["/usr/bin" "/bin"];
    };

  /**
   * Initial standard environment based on MSYS tools.
   * From this point, cygwin should no longer by involved.
   */
  stdenvInit2 =
    import ./simple-stdenv {
      name = "stdenv-initial-msys";
      inherit system;
      shell = msys + /bin/sh + ".exe";
      path = [msys];

      /**
       * Instruct MSYS to change the uname
       * The PATH manipulation in /etc/profile is not relevant for now:
       * This will be overridden anyway.
       */
      extraEnv = {
        MSYSTEM = "MSYS";
      };
    };

  /**
   * Fetchurl, based on native curl in stdenvInit1
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
      src = ./msys-1.0.11.tar.gz; 
      /* fetchurl {
        url = http://www.cs.uu.nl/people/martin/msys-1.0.11.tar.gz;
        md5 = "7e76eec10a205ea63ada6a4e834cc468";
      }; */
    };

  /**
   * Complete standard environment
   */
  body =
    import ../generic {
      name = "stdenv-mingw";
      # preHook = ./prehook.sh;
      initialPath = [msys];
      stdenv = stdenvInit2;
      shell = msys + /bin/sh + ".exe";
      gcc = msys;
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
