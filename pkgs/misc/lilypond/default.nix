{ stdenv, fetchurl, ghostscript, texinfo, imagemagick, texi2html, guile
, python, gettext, flex, perl, bison, pkgconfig, texLive, dblatex
, fontconfig, freetype, pango, fontforge, help2man, zip, netpbm, groff 
, fetchsvn, makeWrapper }:

stdenv.mkDerivation rec{
  majorVersion="2.16";
  minorVersion="2";
  version="${majorVersion}.${minorVersion}";
  name = "lilypond-${version}";

  urwfonts = fetchsvn {
    url = "http://svn.ghostscript.com/ghostscript/tags/urw-fonts-1.0.7pre44";
    sha256 = "0al5vdsb66db6yzwi0qgs1dnd1i1fb77cigdjxg8zxhhwf6hhwpn";
  };

  src = fetchurl {
    url = "http://download.linuxaudio.org/lilypond/sources/v${majorVersion}/lilypond-${version}.tar.gz";
    sha256 = "1jx11bk3rk3w7bnh0829yy280627ywsvwg6fhdm0fqwkiz7jchqz";
  };

  preConfigure=''
    sed -e "s@mem=mf2pt1@mem=$PWD/mf/mf2pt1@" -i scripts/build/mf2pt1.pl
  '';

  postInstall = ''
    for f in "$out"/bin/*; do
        wrapProgram "$f" --set GUILE_AUTO_COMPILE 0 \
                         --set PATH "${ghostscript}/bin"
    done
  '';

  configureFlags = [ "--disable-documentation" "--with-ncsb-dir=${urwfonts}"];

  buildInputs =
    [ ghostscript texinfo imagemagick texi2html guile dblatex zip netpbm
      python gettext flex perl bison pkgconfig texLive fontconfig freetype pango
      fontforge help2man groff makeWrapper
    ];

  meta = { 
    description = "Music typesetting system";
    homepage = http://lilypond.org/;
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };

  patches = [ ./findlib.patch ];
}
