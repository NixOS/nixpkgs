{
  stdenv,
  lib,
  fetchurl,
  ghostscript,
  gyre-fonts,
  texinfo,
  imagemagick,
  texi2html,
  extractpdfmark,
  guile,
  python3,
  gettext,
  glib,
  gmp,
  flex,
  perl,
  bison,
  pkg-config,
  autoreconfHook,
  dblatex,
  fontconfig,
  freetype,
  pango,
  fontforge,
  help2man,
  freefont_ttf,
  makeFontsConf,
  makeWrapper,
  t1utils,
  boehmgc,
  rsync,
  coreutils,
  texliveSmall,
  tex ? texliveSmall.withPackages (
    ps: with ps; [
      lh
      metafont
      epsf
      fontinst
    ]
  ),
}:

stdenv.mkDerivation rec {
  pname = "lilypond";
  version = "2.24.4";

  src = fetchurl {
    url = "http://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-6W+gNXHHnyDhl5ZTr6vb5O5Cdlo9n9FJU/DNnupReBw=";
  };

  postInstall = ''
    for f in "$out/bin/"*; do
        # Override default argv[0] setting so LilyPond can find
        # its Scheme libraries.
        wrapProgram "$f" \
          --set GUILE_AUTO_COMPILE 0 \
          --prefix PATH : "${
            lib.makeBinPath [
              ghostscript
              coreutils
              (placeholder "out")
            ]
          }" \
          --argv0 "$f"
    done
  '';

  configureFlags = [
    "--disable-documentation"
    # FIXME: these URW fonts are not OTF, configure reports "URW++ OTF files... no".
    "--with-urwotf-dir=${ghostscript.fonts}/share/fonts"
    "--with-texgyre-dir=${gyre-fonts}/share/fonts/truetype/"
  ];

  preConfigure = ''
    substituteInPlace scripts/build/mf2pt1.pl \
      --replace-fail "mem=mf2pt1" "mem=$PWD/mf/mf2pt1"
    export HOME=$TMPDIR/home
  '';

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    dblatex
    extractpdfmark
    flex # for flex binary
    fontconfig
    fontforge
    gettext
    ghostscript
    guile
    help2man
    imagemagick
    makeWrapper
    perl
    pkg-config
    python3
    rsync
    t1utils
    tex
    texi2html
    texinfo
  ];

  buildInputs = [
    boehmgc
    flex # FlexLexer.h
    freetype
    glib
    gmp
    pango
  ];

  autoreconfPhase = "NOCONFIGURE=1 sh autogen.sh";

  enableParallelBuilding = true;

  passthru.updateScript = {
    command = [ ./update.sh ];
    supportedFeatures = [ "commit" ];
  };

  meta = {
    description = "Music typesetting system";
    homepage = "https://lilypond.org/";
    license = with lib.licenses; [
      gpl3Plus # most code
      gpl3Only # ly/articulate.ly
      ofl # mf/
    ];
    maintainers = with lib.maintainers; [
      marcweber
      yurrriq
    ];
    platforms = lib.platforms.all;
  };

  FONTCONFIG_FILE = lib.optional stdenv.hostPlatform.isDarwin (makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  });
}
