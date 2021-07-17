{
  lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config
  , asciidoc, libxslt, libxml2, docbook_xml_dtd_45, docbook_xsl
  , libarchive, xz
}:
stdenv.mkDerivation rec {
  baseName = "pixz";
  version = "1.0.7";
  name = "${baseName}-${version}";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    autoconf automake libtool asciidoc libxslt libxml2
    docbook_xml_dtd_45 docbook_xsl
    libarchive xz
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
    description = "A parallel compressor/decompressor for xz format";
    license = lib.licenses.bsd2;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
