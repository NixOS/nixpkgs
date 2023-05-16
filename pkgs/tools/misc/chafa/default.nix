{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, which
, libxslt, libxml2, docbook_xml_dtd_412, docbook_xsl, glib, imagemagick
, Foundation
}:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.12.5";
=======
  version = "1.12.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-2li2Vp+W4Q2/8WY8FJ519BuVR9KzddIJ1j/GY/hLMZo=";
=======
    sha256 = "sha256-rW3QHf7T3mXWxTCcUPriu+iZohbwGNxWRmquXdSMPQk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  # https://github.com/NixOS/nixpkgs/pull/240893#issuecomment-1635347507
  NIX_LDFLAGS = [ "-lwebp" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Terminal graphics for the 21st century";
    homepage = "https://hpjansson.org/chafa/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.mog ];
  };
}
