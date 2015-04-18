{ stdenv, lib, fetchFromGitHub, pkgconfig, openssl, curl, libxml2, libxslt, asciidoc, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "lastpass-cli-${version}";

  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = "lastpass-cli";
    rev = "v${version}";
    sha256 = "1r06lifjc28sm88d6x3xwn76l9fjwjmd1wbmvr9j8rna889q0wl9";
  };

  buildInputs = [
    openssl curl libxml2 pkgconfig asciidoc docbook_xsl libxslt
  ];

  prePatch = ''
    substituteInPlace version.h --replace "0.3.0" "0.4.0"
  '';

  makeFlags = "PREFIX=$(out)";

  installTargets = "install install-doc";

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = "https://github.com/lastpass/lastpass-cli";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
