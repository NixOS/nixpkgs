{ fetchFromGitHub
, stdenv
, python
, autoreconfHook

, libxml2
, libxslt
, docbook_xml_dtd_45
, docbook_xsl_ns
, docbook_xsl
}:

stdenv.mkDerivation rec {
  pname = "asciidoc";
  version = "9.0.3";

  src = fetchFromGitHub {
    owner = "asciidoc";
    repo = "asciidoc-py3";
    rev = version;
    sha256 = "129wm790b7c86clwwcqjy2ri72lwq8fyxkxw4dfj9a2r50xhlfri";
  };

  nativeBuildInputs = [ python autoreconfHook libxml2 libxslt docbook_xml_dtd_45 docbook_xsl_ns docbook_xsl ];

  preBuild = ''
    patchShebangs asciidoc.py
  '';

  postInstall = ''
    patchShebangs $out/bin/a2x.py
    patchShebangs $out/bin/asciidoc.py
  '';

  meta = with stdenv.lib; {
    description = "Text-based document generation system";
    longDescription = ''
      AsciiDoc is a text document format for writing notes, documentation,
      articles, books, ebooks, slideshows, web pages, man pages and blogs.
      AsciiDoc files can be translated to many formats including HTML, PDF,
      EPUB, man page.

      AsciiDoc is highly configurable: both the AsciiDoc source file syntax and
      the backend output markups (which can be almost any type of SGML/XML
      markup) can be customized and extended by the user.
    '';
    homepage = "http://www.methods.co.nz/asciidoc/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
