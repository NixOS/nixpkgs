{ stdenv, fetchurl
# TODO: links -lsigsegv but loses the reference for some reason
, withSigsegv ? (false && stdenv.hostPlatform.system != "x86_64-cygwin"), libsigsegv
, interactive ? false, readline

/* Test suite broke on:
       stdenv.isCygwin # XXX: `test-dup2' segfaults on Cygwin 6.1
    || stdenv.isDarwin # XXX: `locale' segfaults
    || stdenv.isSunOS  # XXX: `_backsmalls1' fails, locale stuff?
    || stdenv.isFreeBSD
*/
, doCheck ? (interactive && stdenv.isLinux), glibcLocales ? null
, locale ? null
}:

assert (doCheck && stdenv.isLinux) -> glibcLocales != null;

let
  inherit (stdenv.lib) optional;

  name = "gawk-4.2.1";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.xz";
    sha256 = "0lam2zf3n7ak4pig8w46lhx9hzx50kj2v2yj1616mm26wy2rf4fi";
  };

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/gawk/;
    description = "GNU implementation of the Awk programming language";

    longDescription = ''
      Many computer users need to manipulate text files: extract and then
      operate on data from parts of certain lines while discarding the rest,
      make changes in various text files wherever certain patterns appear,
      and so on.  To write a program to do these things in a language such as
      C or Pascal is a time-consuming inconvenience that may take many lines
      of code.  The job is easy with awk, especially the GNU implementation:
      Gawk.

      The awk utility interprets a special-purpose programming language that
      makes it possible to handle many data-reformatting jobs with just a few
      lines of code.
    '';

    license = licenses.gpl3Plus;

    platforms = platforms.unix ++ platforms.windows;

    maintainers = [ ];
  };
in

if stdenv.hostPlatform.isWindows then
  stdenv.mkDerivation rec {
    inherit src name meta;

    # $src/pc has pre-configured makefiles for Windows
    configurePhase = ''
      substituteInPlace pc/gawkmisc.pc    --replace 'int execvp(const char *file, const char *const *argv)' 'int execvp(const char *file, char *const *argv)'
      substituteInPlace pc/Makefile       --replace CC=gcc               CC=${stdenv.cc.targetPrefix}cc
      substituteInPlace pc/Makefile       --replace 'prefix = c:/gnu'    "prefix = $out"
      substituteInPlace pc/Makefile.ext   --replace 'prefix = c:/gnu'    "prefix = $out"
      sed -i -r 's,\tgcc ,\t${stdenv.cc.targetPrefix}cc ,g' pc/Makefile.ext

      mv pc/Makefile.ext ./extension/Makefile
      mv pc/{Makefile,config.h,popen.h,socket.h,dlfcn.h,in.h,getid.c,popen.c} ./
      mv support/{dfa.h,random.h,getopt.h,regex.h,getopt_int.h,xalloc.h,regex_internal.h,localeinfo.h,regcomp.c,regexec.c,regex_internal.c,localeinfo.c,dfa.c,getopt.c,random.c,regex.c,getopt1.c} ./
    '';

    buildPhase = ''
      make mingw32
      ( cd extension; make extensions MPFR= MPFR_LIBS= )
    '';

    preInstall = ''mkdir -p $out/lib'';
  }
else
  stdenv.mkDerivation rec {
    inherit src name meta;

    # When we do build separate interactive version, it makes sense to always include man.
    outputs = [ "out" "info" ] ++ optional (!interactive) "man";

    nativeBuildInputs = optional (doCheck && stdenv.isLinux) glibcLocales;

    buildInputs =
         optional withSigsegv libsigsegv
      ++ optional interactive readline
      ++ optional stdenv.isDarwin locale;

    configureFlags = [
      (if withSigsegv then "--with-libsigsegv-prefix=${libsigsegv}" else "--without-libsigsegv")
      (if interactive then "--with-readline=${readline.dev}" else "--without-readline")
    ];

    makeFlags = "AR=${stdenv.cc.targetPrefix}ar";

    inherit doCheck;

    postInstall = ''
      rm "$out"/bin/gawk-*
      ln -s gawk.1 "''${!outputMan}"/share/man/man1/awk.1
    '';

    passthru = {
      libsigsegv = if withSigsegv then libsigsegv else null; # for stdenv bootstrap
    };

  }
