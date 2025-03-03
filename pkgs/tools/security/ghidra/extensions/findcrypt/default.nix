{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
let
  version = "3.0.4";
in
buildGhidraExtension {
  pname = "findcrypt";
  inherit version;

  src = fetchFromGitHub {
    owner = "antoniovazquezblanco";
    repo = "GhidraFindcrypt";
    rev = "v${version}";
    hash = "sha256-wISG3JGKyEeWhwRQqzam+Y4N9EoNcy6AdSGfj0zd18w=";
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
