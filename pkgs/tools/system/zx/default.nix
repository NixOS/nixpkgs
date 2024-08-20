{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "zx";
  version = "8.1.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = version;
    hash = "sha256-9B/X7lOaNTXRGIteGDnLexVF8joo1m+xsfaqxTL2150=";
  };

  npmDepsHash = "sha256-HNaREvW8opvxjZWJ7cFrIoF1JELWBemr8VB9DyYdNfA=";

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    changelog = "https://github.com/google/zx/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlbribeiro ];
    mainProgram = "zx";
  };
}
