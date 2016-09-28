{ stdenv, lib, fetchFromGitHub, pkgconfig, openssl, curl, libxml2, libxslt, asciidoc, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "lastpass-cli-${version}";

  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = "lastpass-cli";
    rev = "v${version}";
    sha256 = "0hidx2qfr52bwjb6as4fbfa34jqh3zwvrcx590vbsji3bq4g7avb";
  };

  buildInputs = [
    openssl curl libxml2 pkgconfig asciidoc docbook_xsl libxslt
  ];

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
