{
  lib,
  callPackage,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  cython,
  spacy,
  numpy,
  transformers,
  torch,
  srsly,
  spacy-alignments,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spacy-transformers";
  version = "1.3.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spacy-transformers";
    tag = "release-v${version}";
    hash = "sha256-06M/e8/+hMVQdZfqyI3qGaZY7iznMwMtblEkFR6Sro0=";
  };

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
    spacy
    numpy
    transformers
    torch
    srsly
    spacy-alignments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonRelaxDeps = [ "transformers" ];

  # Test fails due to missing arguments for trfs2arrays().
  doCheck = false;

  pythonImportsCheck = [ "spacy_transformers" ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = {
    description = "spaCy pipelines for pretrained BERT, XLNet and GPT-2";
    homepage = "https://github.com/explosion/spacy-transformers";
    changelog = "https://github.com/explosion/spacy-transformers/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
