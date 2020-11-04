{ stdenv, lib, fetchurl, ghostscript, gyre-fonts, texinfo, imagemagick, texi2html, guile
, python2, gettext, flex, perl, bison, pkgconfig, autoreconfHook, dblatex
, fontconfig, freetype, pango, fontforge, help2man, zip, netpbm, groff
, makeWrapper, t1utils
, texlive, tex ? texlive.combine {
    inherit (texlive) scheme-small lh metafont epsf;
  }
}:

stdenv.mkDerivation rec {
  pname = "lilypond";
  version = "2.20.0";

  src = fetchurl {
    url = "http://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    sha256 = "0qd6pd4siss016ffmcyw5qc6pr2wihnvrgd4kh1x725w7wr02nar";
  };

  patches = [
    ./findlib.patch
    (fetchurl {
      name = "CVE-2020-17353.patch";
      url = "https://git.savannah.gnu.org/gitweb/?p=lilypond.git;a=commitdiff_plain;h=b84ea4740f3279516905c5db05f4074e777c16ff;hp=b97bd35ac99efd68569327f62f3c8a19511ebe43";
      sha256 = "1i79gy3if070rdgj7j6inw532j0f6ya5qc6kgcnlkbx02rqrhr7v";
    })
  ];

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

  nativeBuildInputs = [ autoreconfHook bison flex makeWrapper pkgconfig ];

  buildInputs =
    [ ghostscript texinfo imagemagick texi2html guile dblatex tex zip netpbm
      python2 gettext perl fontconfig freetype pango
      fontforge help2man groff t1utils
    ];

  autoreconfPhase = "NOCONFIGURE=1 sh autogen.sh";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Music typesetting system";
    homepage = "http://lilypond.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marcweber yurrriq ];
    platforms = platforms.all;
  };
}
