{
  lib,
  stdenv,
  fetchurl,
  removeReferencesTo,
  runtimeShellPackage,
  texinfo,
  interactive ? false,
  readline,
  autoreconfHook, # no-pma fix

  /*
    Test suite broke on:
        stdenv.hostPlatform.isCygwin # XXX: `test-dup2' segfaults on Cygwin 6.1
     || stdenv.hostPlatform.isDarwin # XXX: `locale' segfaults
     || stdenv.hostPlatform.isSunOS  # XXX: `_backsmalls1' fails, locale stuff?
     || stdenv.hostPlatform.isFreeBSD
  */
  doCheck ? (interactive && stdenv.hostPlatform.isLinux),
  glibcLocales ? null,
  locale ? null,
}:

assert (doCheck && stdenv.hostPlatform.isLinux) -> glibcLocales != null;

stdenv.mkDerivation rec {
  pname = "gawk" + lib.optionalString interactive "-interactive";
  version = "5.3.2";

  src = fetchurl {
    url = "mirror://gnu/gawk/gawk-${version}.tar.xz";
    hash = "sha256-+MNIZQnecFGSE4sA7ywAu73Q6Eww1cB9I/xzqdxMycw=";
  };

  # When we do build separate interactive version, it makes sense to always include man.
  outputs = [
    "out"
    "info"
  ]
  ++ lib.optional (!interactive) "man";

  strictDeps = true;

  # no-pma fix
  nativeBuildInputs = [
    autoreconfHook
    texinfo
  ]
  ++ lib.optionals interactive [
    removeReferencesTo
  ]
  ++ lib.optionals (doCheck && stdenv.hostPlatform.isLinux) [
    glibcLocales
  ];

  buildInputs =
    lib.optionals interactive [
      runtimeShellPackage
      readline
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      locale
    ];

  configureFlags = [
    (if interactive then "--with-readline=${readline.dev}" else "--without-readline")
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # TODO: figure out a better way to unbreak _NSGetExecutablePath invocations
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  };

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  inherit doCheck;

  postInstall =
    (
      if interactive then
        ''
          remove-references-to -t "$NIX_CC" "$out"/bin/gawkbug
          patchShebangs --host "$out"/bin/gawkbug
        ''
      else
        ''
          rm "$out"/bin/gawkbug
        ''
    )
    + ''
      rm "$out"/bin/gawk-*
      ln -s gawk.1 "''${!outputMan}"/share/man/man1/awk.1
    '';

  meta = {
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
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    teams = [ lib.teams.helsinki-systems ];
    mainProgram = "gawk";
  };
}
