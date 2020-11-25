{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig
, asciidoc, libxslt, libxml2, docbook_xml_dtd_45, docbook_xsl
, libarchive, lzma
}:

stdenv.mkDerivation rec {
  pname = "pixz";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "vasi";
    repo = pname;
    rev = "v${version}";
    sha256 = "163axxs22w7pghr786hda22mnlpvmi50hzhfr9axwyyjl9n41qs2";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake ];

  buildInputs = [
    libtool asciidoc libxslt libxml2
    docbook_xml_dtd_45 docbook_xsl
    libarchive lzma
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A parallel compressor/decompressor for xz format";
    license = licenses.bsd2;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
  };
}
