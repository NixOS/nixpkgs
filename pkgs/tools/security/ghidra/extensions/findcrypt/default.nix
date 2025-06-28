{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
let
  version = "3.0.6";
in
buildGhidraExtension {
  pname = "findcrypt";
  inherit version;

  src = fetchFromGitHub {
    owner = "antoniovazquezblanco";
    repo = "GhidraFindcrypt";
    rev = "v${version}";
    hash = "sha256-VWi1MP72Vl4XCrbTvRA6qYPk2QyvRyVb9N8QQ/Zml0A=";
  };

  meta = {
    description = "Ghidra analysis plugin to locate cryptographic constants";
    homepage = "https://github.com/antoniovazquezblanco/GhidraFindcrypt";
    downloadPage = "https://github.com/antoniovazquezblanco/GhidraFindcrypt/releases/tag/v${version}";
    changelog = "https://github.com/antoniovazquezblanco/GhidraFindcrypt/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.BonusPlay ];
  };
}
