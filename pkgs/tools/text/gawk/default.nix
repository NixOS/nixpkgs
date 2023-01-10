{ lib, stdenv, fetchurl
# TODO: links -lsigsegv but loses the reference for some reason
, withSigsegv ? (false && stdenv.hostPlatform.system != "x86_64-cygwin"), libsigsegv
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
  version = "5.2.1";

  src = fetchurl {
    url = "mirror://gnu/gawk/gawk-${version}.tar.xz";
    hash = "sha256-ZzVTuR+eGMxXku1RB1341RDJBA9VCm904Jya3SQ6fk8=";
  };

  patches = [
    # Pull upstream fix for aarch64-darwin where pma does not work.
    # Can be removed after next gawk release.
    ./darwin-no-pma.patch
  ];

  # When we do build separate interactive version, it makes sense to always include man.
  outputs = [ "out" "info" ]
    ++ lib.optional (!interactive) "man";

  nativeBuildInputs = lib.optional (doCheck && stdenv.isLinux) glibcLocales
    # no-pma fix
    ++ [ autoreconfHook ];

  buildInputs = lib.optional withSigsegv libsigsegv
    ++ lib.optional interactive readline
    ++ lib.optional stdenv.isDarwin locale;

  configureFlags = [
    (if withSigsegv then "--with-libsigsegv-prefix=${libsigsegv}" else "--without-libsigsegv")
    (if interactive then "--with-readline=${readline.dev}" else "--without-readline")
  ]
  # nixpkgs on musl targets defaults to CFLAGS=-fPIE. That is incompatible with
  # LDFLAGS=-no-pie that --enable-pma requests. Until gawk is fixed let's disable
  # pma on affected targets. Can be dropped when patch is upstreamed:
  #   https://lists.gnu.org/archive/html/bug-gawk/2023-01/msg00014.html
  ++ lib.optionals (stdenv.hostPlatform.isMusl) [
    "--disable-pma"
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  inherit doCheck;

  postInstall = ''
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
  };
}
