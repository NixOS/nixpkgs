{ stdenv, lib, fetchFromGitHub, asciidoc, cmake, docbook_xsl, pkgconfig
, bash-completion, openssl, curl, libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "lastpass-cli-${version}";

  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = "lastpass-cli";
    rev = "v${version}";
    sha256 = "0041z2awpmwq2fk8lbgp4fcia0r6wss2csvq5bxps0cx7fq69wc1";
  };

  nativeBuildInputs = [ asciidoc cmake docbook_xsl pkgconfig ];

  buildInputs = [
    bash-completion curl openssl libxml2 libxslt
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBASH_COMPLETION_COMPLETIONSDIR=./share/bash-completion/completions"
  ];

  installTargets = "install install-doc";

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = "https://github.com/lastpass/lastpass-cli";
    license     = licenses.gpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
