{ lib, stdenv, fetchurl
, removeReferencesTo
, runtimeShellPackage
# TODO: links -lsigsegv but loses the reference for some reason
, withSigsegv ? (false && stdenv.hostPlatform.system != "x86_64-cygwin"), libsigsegv
, interactive ? false, readline
, autoreconfHook # no-pma fix

/* Test suite broke on:
       stdenv.hostPlatform.isCygwin # XXX: `test-dup2' segfaults on Cygwin 6.1
    || stdenv.hostPlatform.isDarwin # XXX: `locale' segfaults
    || stdenv.hostPlatform.isSunOS  # XXX: `_backsmalls1' fails, locale stuff?
    || stdenv.hostPlatform.isFreeBSD
*/
, doCheck ? (interactive && stdenv.hostPlatform.isLinux), glibcLocales ? null
, locale ? null
}:

assert (doCheck && stdenv.hostPlatform.isLinux) -> glibcLocales != null;

stdenv.mkDerivation rec {
  pname = "gawk" + lib.optionalString interactive "-interactive";
  version = "5.2.2";

  src = fetchurl {
    url = "mirror://gnu/gawk/gawk-${version}.tar.xz";
    hash = "sha256-PB/OFEa0y+4c0nO9fsZLyH2J9hU3RxzT4F4zqWWiUOk=";
  };

  # PIE is incompatible with the "persistent malloc" ("pma") feature.
  # While build system attempts to pass -no-pie to gcc. nixpkgs' `ld`
  # wrapped still passes `-pie` flag to linker and breaks linkage.
  # Let's disable "pie" until `ld` is fixed to do the right thing.
  hardeningDisable = [ "pie" ];

  # When we do build separate interactive version, it makes sense to always include man.
  outputs = [ "out" "info" ]
    ++ lib.optional (!interactive) "man";

  strictDeps = true;

  # no-pma fix
  nativeBuildInputs = [
    autoreconfHook
  ] ++ lib.optionals interactive [
    removeReferencesTo
  ] ++ lib.optionals (doCheck && stdenv.hostPlatform.isLinux) [
    glibcLocales
  ];

  buildInputs = lib.optionals interactive [
    runtimeShellPackage
    readline
  ] ++ lib.optionals withSigsegv [
    libsigsegv
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    locale
  ];

  configureFlags = [
    (if withSigsegv then "--with-libsigsegv-prefix=${libsigsegv}" else "--without-libsigsegv")
    (if interactive then "--with-readline=${readline.dev}" else "--without-readline")
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  inherit doCheck;

  postInstall = (if interactive then ''
    remove-references-to -t "$NIX_CC" "$out"/bin/gawkbug
    patchShebangs --host "$out"/bin/gawkbug
  '' else ''
    rm "$out"/bin/gawkbug
  '') + ''
    rm "$out"/bin/gawk-*
    ln -s gawk.1 "''${!outputMan}"/share/man/man1/awk.1
  '';

  passthru = {
    libsigsegv = if withSigsegv then libsigsegv else null; # for stdenv bootstrap
  };

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
