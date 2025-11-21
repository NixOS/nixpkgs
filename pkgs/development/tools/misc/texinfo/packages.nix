{
  lib,
  stdenv,
  buildPackages,
  callPackage,
  fetchurl,
  perl,
  libintl,
  bashNonInteractive,
  updateAutotoolsGnuConfigScriptsHook,
  gawk,
  freebsd,
  libiconv,

  # we are a dependency of gcc, this simplifies bootstrapping
  interactive ? false,
  ncurses,
  procps,
}:

let
  meta = {
    description = "GNU documentation system";
    homepage = "https://www.gnu.org/software/texinfo/";
    changelog = "https://git.savannah.gnu.org/cgit/texinfo.git/plain/NEWS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ oxij ];

    longDescription = ''
      Texinfo is the official documentation format of the GNU project.
      It was invented by Richard Stallman and Bob Chassell many years
      ago, loosely based on Brian Reid's Scribe and other formatting
      languages of the time.  It is used by many non-GNU projects as
      well.

      Texinfo uses a single source file to produce output in a number
      of formats, both online and printed (dvi, html, info, pdf, xml,
      etc.).  This means that instead of writing different documents
      for online information and another for a printed manual, you
      need write only one document.  And when the work is revised, you
      need revise only that one document.  The Texinfo system is
      well-integrated with GNU Emacs.
    '';
    mainProgram = "texi2any";
  };
  buildTexinfo = callPackage ./common.nix {
    inherit
      lib
      stdenv
      buildPackages
      updateAutotoolsGnuConfigScriptsHook
      fetchurl
      perl
      libintl
      libiconv
      bashNonInteractive
      gawk
      freebsd
      ncurses
      procps
      meta
      interactive
      ;
  };
in
{
  texinfo6 = buildTexinfo {
    version = "6.8";
    hash = "sha256-jrdT7Si8oh+PVsGhgDYq7XiSKb1i//WL+DaOm+tZ/sQ=";
    patches = [ ./fix-glibc-2.34.patch ];
  };
  texinfo7 = buildTexinfo {
    version = "7.2";
    hash = "sha256-AynXeI++8RP6gsuAiJyhl6NEzg33ZG/gAJdMXXFDY6Y=";
  };
}
