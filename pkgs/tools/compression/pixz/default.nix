{
  stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig
  , asciidoc, libxslt, libxml2, docbook_xml_dtd_45, docbook_xsl
  , libarchive, lzma
}:
stdenv.mkDerivation rec {
  baseName = "pixz";
  version = "1.0.7";
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
    sha256 = "163axxs22w7pghr786hda22mnlpvmi50hzhfr9axwyyjl9n41qs2";
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
