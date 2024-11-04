{
  lib,
  stdenv,
  buildPackages,
  callPackage,
  fetchurl,
  perl,
  libintl,
  bash,
  updateAutotoolsGnuConfigScriptsHook,
  gnulib,
  gawk,
  freebsd,
  libiconv,
  xz,

  # we are a dependency of gcc, this simplifies bootstraping
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
      xz
      libintl
      libiconv
      bash
      gnulib
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
  texinfo413 = stdenv.mkDerivation (finalAttrs: {
    pname = "texinfo";
    version = "4.13a";

    src = fetchurl {
      url = "mirror://gnu/texinfo/texinfo-${finalAttrs.version}.tar.lzma";
      hash = "sha256-bSiwzq6GbjU2FC/FUuejvJ+EyDAxGcJXMbJHju9kyeU=";
    };

    buildInputs = [ ncurses ];
    nativeBuildInputs = [ xz ];

    # Disabled because we don't have zdiff in the stdenv bootstrap.
    #doCheck = true;

    meta = meta // {
      branch = finalAttrs.version;
    };
  });
  texinfo6_5 = buildTexinfo {
    version = "6.5";
    hash = "sha256-d3dLP0oGwgcFzC7xyASGRCLjz5UjXpZbHwCkbffaX2I=";
  };
  texinfo6_7 = buildTexinfo {
    version = "6.7";
    hash = "sha256-mIQDwVQtFa0ERgC5CZl7owebEOAyJMYRiBF/NnawLKo=";
  };
  texinfo6 = buildTexinfo {
    version = "6.8";
    hash = "sha256-jrdT7Si8oh+PVsGhgDYq7XiSKb1i//WL+DaOm+tZ/sQ=";
    patches = [ ./fix-glibc-2.34.patch ];
  };
  texinfo7 = buildTexinfo {
    version = "7.1.1";
    hash = "sha256-Ma435GKDUpQythvuHOAe0AkNWZ5gb8aincofd8dqbII=";
  };
}
