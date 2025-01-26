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
  version = "1.3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spacy-transformers";
    tag = "release-v${version}";
    hash = "sha256-VZEx7mDTqcJ7c0qqDYc3GZzesqi/MwJawAZDUGdXMB0=";
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

  meta = with lib; {
    description = "spaCy pipelines for pretrained BERT, XLNet and GPT-2";
    homepage = "https://github.com/explosion/spacy-transformers";
    changelog = "https://github.com/explosion/spacy-transformers/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
