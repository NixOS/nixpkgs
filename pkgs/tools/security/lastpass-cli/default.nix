{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, openssl, curl, libxml2, libxslt, asciidoc, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "lastpass-cli-${version}";

  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = "lastpass-cli";
    rev = "v${version}";
    sha256 = "0nrsrd5cqyv2zydzzl1vryrnj1p0x17cx1rmrp4kmzh83bzgcfvv";
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
