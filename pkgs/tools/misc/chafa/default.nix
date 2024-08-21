{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, which
, libxslt, libxml2, docbook_xml_dtd_412, docbook_xsl, glib, imagemagick
, Foundation
}:

stdenv.mkDerivation rec {
  version = "1.14.2";
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    rev = version;
    sha256 = "sha256-BK2QTlcns+e3LL3NgcVYk4an+j/x0btpKAuBZ+QIN+Q=";
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
    substituteInPlace ./autogen.sh --replace pkg-config '$PKG_CONFIG'
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [ "--enable-man"
                     "--with-xml-catalog=${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml"
                   ];

  # https://github.com/NixOS/nixpkgs/pull/240893#issuecomment-1635347507
  NIX_LDFLAGS = [ "-lwebp" ];

  meta = with lib; {
    description = "Terminal graphics for the 21st century";
    homepage = "https://hpjansson.org/chafa/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.mog ];
    mainProgram = "chafa";
  };
}
