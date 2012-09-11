{ stdenv, fetchurl, ghostscript, texinfo, imagemagick, texi2html, guile
, python, gettext, flex, perl, bison, pkgconfig, texLive, dblatex
, fontconfig, freetype, pango, fontforge, help2man, zip, netpbm, groff 
, fetchsvn }:

stdenv.mkDerivation rec{
  majorVersion="2.14";
  minorVersion="2";
  version="${majorVersion}.${minorVersion}";
  name = "lilypond-${version}";

  urwfonts = fetchsvn {
    url = "http://svn.ghostscript.com/ghostscript/tags/urw-fonts-1.0.7pre44";
    sha256 = "0al5vdsb66db6yzwi0qgs1dnd1i1fb77cigdjxg8zxhhwf6hhwpn";
  };

  src = fetchurl {
    url = "http://download.linuxaudio.org/lilypond/sources/v${majorVersion}/lilypond-${version}.tar.gz";
    # 2.15.42
    # sha256 = "0cm2fq1cr9d24w5xkz6ik6qnby516dfahz4cw47xx8mb5qsa4drd";
    sha256 = "15i6k3fjc29wvchayn31khxhpppzd4g6ivbk7l43fakj8lw6nfi4";
  };

  preConfigure=''
    sed -e "s@mem=mf2pt1@mem=$PWD/mf/mf2pt1@" -i scripts/build/mf2pt1.pl
  '';

  configureFlags = [ "--disable-documentation" "--with-ncsb-dir=${urwfonts}"];

  buildInputs =
    [ ghostscript texinfo imagemagick texi2html guile dblatex zip netpbm
      python gettext flex perl bison pkgconfig texLive fontconfig freetype pango
      fontforge help2man groff
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
