{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, which, libxslt, libxml2, docbook_xml_dtd_412, docbook_xsl, glib, imagemagick, darwin }:


stdenv.mkDerivation rec {
  version = "1.6.0";
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    rev = version;
    sha256 = "sha256-GaXVMM23U3M+qNJrWYR+DLiCmILcuX5EIkQqzwN/l1Y=";
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

  buildInputs = [ glib imagemagick ] ++ lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.ApplicationServices ];

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
