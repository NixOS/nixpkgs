{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "findcrypt";
<<<<<<< HEAD
  version = "3.1.3";
=======
  version = "3.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "antoniovazquezblanco";
    repo = "GhidraFindcrypt";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-c+7WQ7EeZm/9IyqGthTKBtm7EnNp0o7BmIM6GskTo6Y=";
=======
    hash = "sha256-KP6Wx2U8O/37yEAcV3abKg/uWraHJJOIfb7kvcfejHA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
