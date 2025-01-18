{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  curated-tokenizers,
  curated-transformers,
  spacy,
  torch,
}:

buildPythonPackage rec {
  pname = "spacy-curated-transformers";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spacy-curated-transformers";
    tag = "release-v${version}";
    hash = "sha256-3LL0ofVsyacMzLJtttg0Tl9SlkPex7TwWL/HVF4WkfI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    curated-tokenizers
    curated-transformers
    spacy
    torch
  ];

  # Unit tests are hard to use, since most tests rely on downloading
  # models from Hugging Face Hub.
  pythonImportCheck = [ "spacy_curated_transformers" ];

  meta = with lib; {
    description = "spaCy entry points for Curated Transformers";
    homepage = "https://github.com/explosion/spacy-curated-transformers";
    changelog = "https://github.com/explosion/spacy-curated-transformers/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
