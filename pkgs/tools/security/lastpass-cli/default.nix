{ stdenv, lib, fetchFromGitHub, asciidoc, cmake, docbook_xsl, pkgconfig
, bash-completion, openssl, curl, libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "lastpass-cli-${version}";

  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = "lastpass-cli";
    rev = "v${version}";
    sha256 = "11drzmfdvb8ydw1dxaz9zz8rk0jjqmfv076vydz05qqvgx59s38h";
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
