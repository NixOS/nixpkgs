{ stdenv, fetchurl

, SystemConfiguration ? null, Foundation ? null
}:

assert stdenv.isDarwin -> SystemConfiguration != null
                       && Foundation != null;

stdenv.mkDerivation rec {
  version = "1.8.29";
  name = "htmldoc-${version}";
  src = fetchurl {
    url = "https://github.com/michaelrsweet/htmldoc/releases/download"
      + "/release-${version}/htmldoc-${version}-source.tar.gz";
    sha256 = "15x0xdf487j4i4gfap5yr83airxnbp2v4lxaz79a4s3iirrq39p0";
  };
  buildInputs = with stdenv;
       lib.optional isDarwin SystemConfiguration
    ++ lib.optional isDarwin Foundation;

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
