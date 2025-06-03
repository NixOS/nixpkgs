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
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spacy-curated-transformers";
    tag = "release-v${version}";
    hash = "sha256-Y3puV9fDN5mAugLPmXuoIbwUBpSMcmkq+oXAyYdmQew=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "thinc"
  ];

  dependencies = [
    curated-tokenizers
    curated-transformers
    spacy
    torch
  ];

  # Unit tests are hard to use, since most tests rely on downloading
  # models from Hugging Face Hub.
  pythonImportsCheck = [ "spacy_curated_transformers" ];

  meta = {
    description = "spaCy entry points for Curated Transformers";
    homepage = "https://github.com/explosion/spacy-curated-transformers";
    changelog = "https://github.com/explosion/spacy-curated-transformers/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danieldk ];
  };
}
