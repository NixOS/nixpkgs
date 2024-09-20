{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
let
  version = "3.0.1";
in
buildGhidraExtension {
  pname = "findcrypt";
  inherit version;

  src = fetchFromGitHub {
    owner = "antoniovazquezblanco";
    repo = "GhidraFindcrypt";
    rev = "v${version}";
    hash = "sha256-/KA95NdoQFvR6XSGCHkX+ySKfftK84hJ8zjAvt0+O0o=";
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
