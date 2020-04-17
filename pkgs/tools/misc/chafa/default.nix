{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, which, libxslt, libxml2, docbook_xml_dtd_412, docbook_xsl, glib, imagemagick, darwin }:


stdenv.mkDerivation rec{
  version = "1.4.0";
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    rev = version;
    sha256 = "0vf658dd9sb2d3yh65c8nals9z0z7rykqqigmxq2h92x2ysjbg6x";
  };

  nativeBuildInputs = [ autoconf
                        automake
                        libtool
                        pkgconfig
                        which
                        libxslt
                        libxml2
                        docbook_xml_dtd_412
                        docbook_xsl
                      ];

  buildInputs = [ glib imagemagick ] ++ stdenv.lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.ApplicationServices ];

  patches = [ ./xmlcatalog_patch.patch ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--enable-man"
                     "--with-xml-catalog=${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml"
                   ];

  meta = with stdenv.lib; {
    description = "Terminal graphics for the 21st century.";
    homepage = "https://hpjansson.org/chafa/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.mog ];
  };
}
