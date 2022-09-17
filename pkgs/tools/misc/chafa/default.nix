{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, which
, libxslt, libxml2, docbook_xml_dtd_412, docbook_xsl, glib, imagemagick
, Foundation
}:

stdenv.mkDerivation rec {
  version = "1.12.3";
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    rev = version;
    sha256 = "sha256-Aejm3VR4f69jDdG16vud2sj/9jQ8n5f34oed1SGEcXo=";
  };

  nativeBuildInputs = [ autoconf
                        automake
                        libtool
                        pkg-config
                        which
                        libxslt
                        libxml2
                        docbook_xml_dtd_412
                        docbook_xsl
                      ];

  buildInputs = [ glib imagemagick ]
    ++ lib.optional stdenv.isDarwin Foundation;

  patches = [ ./xmlcatalog_patch.patch ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--enable-man"
                     "--with-xml-catalog=${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml"
                   ];

  meta = with lib; {
    description = "Terminal graphics for the 21st century";
    homepage = "https://hpjansson.org/chafa/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.mog ];
  };
}
