{ stdenv, fetchurl

, SystemConfiguration ? null, Foundation ? null
}:

assert stdenv.isDarwin -> SystemConfiguration != null
                       && Foundation != null;

stdenv.mkDerivation {
  name = "htmldoc-1.8.29";
  src = fetchurl {
    url = "https://github.com/michaelrsweet/htmldoc/releases/download"
        + "/release-1.8.29/htmldoc-1.8.29-source.tar.gz";
    md5 = "14d32bd772e2bc6af7b9b2233724c3ec";
  };
  buildInputs =
    stdenv.lib.ifEnable stdenv.isDarwin [SystemConfiguration Foundation];

  meta = with stdenv.lib; {
    description = "Converts HTML files to PostScript and PDF";
    homepage    = https://michaelrsweet.github.io/htmldoc;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ viric shanemikel ];
    platforms   = with platforms; linux ++ darwin;

    longDescription = ''
      HTMLDOC is a program that reads HTML source files or web pages and
      generates corresponding HTML, PostScript, or PDF files with an optional
      table of contents.
    '';
  };
}
