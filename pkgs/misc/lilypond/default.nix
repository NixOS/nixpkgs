{ stdenv, fetchurl, ghostscript, texinfo, imagemagick, texi2html, guile
, python, gettext, flex, perl, bison, pkgconfig, texLive
, fontconfig, freetype, pango, fontforge, help2man }:

stdenv.mkDerivation {
  name = "lilypond-2.13.9";

  src = fetchurl {
    url = http://download.linuxaudio.org/lilypond/sources/v2.13/lilypond-2.13.9.tar.gz;
    sha256 = "1x3jz0zbhly4rc07nry3ia3ydd6vislz81gg0ivwfm6f6q0ssk57";
  };

  configureFlags = [ "--disable-documentation" "--with-ncsb-dir=${ghostscript}/share/ghostscript/fonts"];

  buildInputs =
    [ ghostscript texinfo imagemagick texi2html guile
      python gettext flex perl bison pkgconfig texLive fontconfig freetype pango
      fontforge help2man
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
