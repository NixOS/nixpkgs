{ stdenv, fetchurl, ghostscript, texinfo, imagemagick, texi2html, guile
, python, gettext, flex, perl, bison, pkgconfig, texLive
, fontconfig, freetype, pango, fontforge, help2man }:

stdenv.mkDerivation rec{
  majorVersion="2.13";
  minorVersion="46";
  version="${majorVersion}.${minorVersion}";
  name = "lilypond-${version}";

  src = fetchurl {
    url = "http://download.linuxaudio.org/lilypond/sources/v${majorVersion}/lilypond-${version}.tar.gz";
    sha256 = "370f59d10a3fc74c5790111f7a69e04304eda5384513c95838dda3cc087904e6";
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
