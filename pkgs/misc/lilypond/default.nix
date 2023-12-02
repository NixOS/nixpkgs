{ stdenv, lib, fetchurl, ghostscript, gyre-fonts, texinfo, imagemagick, texi2html, guile_2_2
, python3, gettext, flex, perl, bison, pkg-config, autoreconfHook, dblatex
, fontconfig, freetype, pango, fontforge, help2man, zip, netpbm, groff
, freefont_ttf, makeFontsConf
, makeWrapper, t1utils, boehmgc, rsync
, texlive, tex ? texlive.combine {
    inherit (texlive) scheme-small lh metafont epsf fontinst;
  }
}:

stdenv.mkDerivation rec {
  pname = "lilypond";
  version = "2.24.2";

  src = fetchurl {
    url = "http://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    sha256 = "sha256-eUTmENe08d5Mccz+H73TIB9U+sVFYb3NBIkU+Nu2Ckg=";
  };

  postInstall = ''
    for f in "$out/bin/"*; do
        # Override default argv[0] setting so LilyPond can find
        # its Scheme libraries.
        wrapProgram "$f" --set GUILE_AUTO_COMPILE 0 \
                         --set PATH "${ghostscript}/bin" \
                         --argv0 "$f"
    done
  '';

  configureFlags = [
    "--disable-documentation"
     # FIXME: these URW fonts are not OTF, configure reports "URW++ OTF files... no".
    "--with-urwotf-dir=${ghostscript}/share/ghostscript/fonts"
    "--with-texgyre-dir=${gyre-fonts}/share/fonts/truetype/"
  ];

  preConfigure = ''
    sed -e "s@mem=mf2pt1@mem=$PWD/mf/mf2pt1@" -i scripts/build/mf2pt1.pl
    export HOME=$TMPDIR/home
  '';

  nativeBuildInputs = [ autoreconfHook bison flex makeWrapper pkg-config ];

  buildInputs =
    [ ghostscript texinfo imagemagick texi2html guile_2_2 dblatex tex zip netpbm
      python3 gettext perl fontconfig freetype pango
      fontforge help2man groff t1utils boehmgc rsync
    ];

  autoreconfPhase = "NOCONFIGURE=1 sh autogen.sh";

  enableParallelBuilding = true;

  passthru.updateScript = {
    command = [ ./update.sh ];
    supportedFeatures = [ "commit" ];
  };

  meta = with lib; {
    description = "Music typesetting system";
    homepage = "http://lilypond.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marcweber yurrriq ];
    platforms = platforms.all;
  };

  FONTCONFIG_FILE = lib.optional stdenv.isDarwin (makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  });
}
