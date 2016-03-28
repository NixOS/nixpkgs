{ stdenv, fetchurl, ghostscript, texinfo, imagemagick, texi2html, guile
, python, gettext, flex, perl, bison, pkgconfig, dblatex
, fontconfig, freetype, pango, fontforge, help2man, zip, netpbm, groff
, fetchsvn, makeWrapper, t1utils
, texlive, tex ? texlive.combine {
    inherit (texlive) scheme-small lh metafont epsf;
  }
}:

stdenv.mkDerivation rec{
  majorVersion="2.18";
  minorVersion="2";
  version="${majorVersion}.${minorVersion}";
  name = "lilypond-${version}";

  urwfonts = fetchsvn {
    url = "http://svn.ghostscript.com/ghostscript/tags/urw-fonts-1.0.7pre44";
    sha256 = "0al5vdsb66db6yzwi0qgs1dnd1i1fb77cigdjxg8zxhhwf6hhwpn";
  };

  src = fetchurl {
    url = "http://download.linuxaudio.org/lilypond/sources/v${majorVersion}/lilypond-${version}.tar.gz";
    sha256 = "01xs9x2wjj7w9appaaqdhk15r1xvvdbz9qwahzhppfmhclvp779j";
  };

  preConfigure=''
    sed -e "s@mem=mf2pt1@mem=$PWD/mf/mf2pt1@" -i scripts/build/mf2pt1.pl

    # At some point our fontforge had path 2n…-fontforge-2015… and it
    # confused the version detection…
    sed -re 's%("[$]exe" --version .*)([|\\] *$)%\1 | sed -re "s@/nix/store/[a-z0-9]{32}-@@" \2%' \
      -i configure

    export HOME=$TMPDIR/home
  '';

  postInstall = ''
    for f in "$out/bin/"*; do
        # Override default argv[0] setting so LilyPond can find
        # its Scheme libraries.
        wrapProgram "$f" --set GUILE_AUTO_COMPILE 0 \
                         --set PATH "${ghostscript}/bin" \
                         --argv0 "$f"
    done
  '';

  configureFlags = [ "--disable-documentation" "--with-ncsb-dir=${urwfonts}"];

  buildInputs =
    [ ghostscript texinfo imagemagick texi2html guile dblatex tex zip netpbm
      python gettext flex perl bison pkgconfig fontconfig freetype pango
      fontforge help2man groff makeWrapper t1utils
    ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Music typesetting system";
    homepage = http://lilypond.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.all;
  };

  patches = [ ./findlib.patch ];
}
