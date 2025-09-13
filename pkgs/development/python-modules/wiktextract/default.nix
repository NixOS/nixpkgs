{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  levenshtein,
  nltk,
  pydantic,
  wikitextprocessor,
}:

buildPythonPackage {
  pname = "wiktextract";
  version = "1.99.7-unstable-2025-09-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tatuylonen";
    repo = "wiktextract";
    rev = "1e1a04b3686803899c32db87e18a8954892cc313";
    hash = "sha256-AuwG3Q4d2aiyZc5EqrIBm+M6AJ33sM4JaqTyUam8Ek4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    levenshtein
    nltk
    pydantic
    wikitextprocessor
  ];

  # It requires Internet
  doCheck = false;

  pythonImportsCheck = [ "wiktextract" ];

  meta = {
    description = "Wiktionary dump file parser and multilingual data extractor";
    homepage = "https://github.com/tatuylonen/wiktextract";
    license = with lib.licenses; [
      mit
      cc-by-sa-40 # Needed for certain test files under Wiktionary licence
    ];
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "wiktwords";
  };
}
