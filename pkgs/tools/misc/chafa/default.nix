{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, which, libxslt, libxml2, docbook_xml_dtd_412, docbook_xsl, glib, imagemagick, darwin }:


stdenv.mkDerivation rec {
  version = "1.4.1";
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    rev = version;
    sha256 = "13vv2xmfh0dr949bh75448lidvzwxks6f1mjawdg1q8qwzxhzry4";
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
