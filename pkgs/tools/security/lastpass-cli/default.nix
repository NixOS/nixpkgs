{ stdenv, lib, fetchFromGitHub, pkgconfig, openssl, curl, libxml2, libxslt, asciidoc, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "lastpass-cli-${version}";

  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = "lastpass-cli";
    rev = "v${version}";
    sha256 = "1iaz36bcyss2kahhlm92l7yh26rxvs12wnkkh1289yarl5wi0yld";
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
