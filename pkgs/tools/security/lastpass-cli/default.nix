{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, openssl, curl, libxml2, libxslt, asciidoc, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "lastpass-cli-${version}";

  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = "lastpass-cli";
    rev = "v${version}";
    sha256 = "1slqrv877c1bhivgd2i9cr1lsd72371dpz6a3h6s56l3qbyk28sa";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    openssl curl libxml2 asciidoc docbook_xsl libxslt
  ];

  makeFlags = "PREFIX=$(out)";

  installTargets = "install install-doc";

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = "https://github.com/lastpass/lastpass-cli";
    license     = licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
