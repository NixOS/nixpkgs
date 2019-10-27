{
  stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig
  , asciidoc, libxslt, libxml2, docbook_xml_dtd_45, docbook_xsl
  , libarchive, lzma
}:
stdenv.mkDerivation rec {
  baseName = "pixz";
  version = "1.0.6";
  name = "${baseName}-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoconf automake libtool asciidoc libxslt libxml2
    docbook_xml_dtd_45 docbook_xsl
    libarchive lzma
  ];
  preBuild = ''
    echo "XML_CATALOG_FILES='$XML_CATALOG_FILES'"
  '';
  src = fetchFromGitHub {
    owner = "vasi";
    repo = baseName;
    rev = "v${version}";
    sha256 = "0q61wqg2yxrgd4nc7256mf7izp92is29ll3rax1cxr6fj9jrd8b7";
  };
  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    inherit version;
    description = ''A parallel compressor/decompressor for xz format'';
    license = stdenv.lib.licenses.bsd2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
