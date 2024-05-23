{ lib, stdenv, fetchurl
, interactive ? false, readline
, autoreconfHook # no-pma fix

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

stdenv.mkDerivation rec {
  pname = "gawk" + lib.optionalString interactive "-interactive";
  version = "5.3.0";

  src = fetchurl {
    url = "mirror://gnu/gawk/gawk-${version}.tar.xz";
    hash = "sha256-ypwW09EdD/jGnXncC0cmfhMppps5t5mJVgTtRH08qQs=";
  };

  # PIE is incompatible with the "persistent malloc" ("pma") feature.
  # While build system attempts to pass -no-pie to gcc. nixpkgs' `ld`
  # wrapped still passes `-pie` flag to linker and breaks linkage.
  # Let's disable "pie" until `ld` is fixed to do the right thing.
  hardeningDisable = [ "pie" ];

  # When we do build separate interactive version, it makes sense to always include man.
  outputs = [ "out" "info" ]
    ++ lib.optional (!interactive) "man";

  # no-pma fix
  nativeBuildInputs = [ autoreconfHook ]
    ++ lib.optional (doCheck && stdenv.isLinux) glibcLocales;

  buildInputs = lib.optional interactive readline
    ++ lib.optional stdenv.isDarwin locale;

  configureFlags = [
    (if interactive then "--with-readline=${readline.dev}" else "--without-readline")
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  inherit doCheck;

  postInstall = ''
    rm "$out"/bin/gawk-*
    ln -s gawk.1 "''${!outputMan}"/share/man/man1/awk.1
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/gawk/";
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
    mainProgram = "gawk";
  };
}
