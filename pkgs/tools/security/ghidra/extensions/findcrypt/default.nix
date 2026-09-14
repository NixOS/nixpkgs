{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "findcrypt";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "antoniovazquezblanco";
    repo = "GhidraFindcrypt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NpJx9F21wYvrgELwKjE4bqRAE3lvLwqXbvuCB0HmPgk=";
  };

  meta = {
    description = "Ghidra analysis plugin to locate cryptographic constants";
    homepage = "https://github.com/antoniovazquezblanco/GhidraFindcrypt";
    downloadPage = "https://github.com/antoniovazquezblanco/GhidraFindcrypt/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/antoniovazquezblanco/GhidraFindcrypt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.BonusPlay ];
  };
})
