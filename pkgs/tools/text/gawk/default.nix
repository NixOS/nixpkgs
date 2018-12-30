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
in
stdenv.mkDerivation rec {
  name = "gawk-4.2.1";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.xz";
    sha256 = "0lam2zf3n7ak4pig8w46lhx9hzx50kj2v2yj1616mm26wy2rf4fi";
  };

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

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/gawk/;
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
}

