{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  numpy,
  spacy,
  spacy-alignments,
  srsly,
  torch,
  transformers,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "spacy-transformers";
  version = "1.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spacy-transformers";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-06M/e8/+hMVQdZfqyI3qGaZY7iznMwMtblEkFR6Sro0=";
  };

  # ImportError: cannot import name 'BatchEncoding' from 'transformers.tokenization_utils' (unknown location)
  postPatch = ''
    substituteInPlace \
      spacy_transformers/data_classes.py \
      spacy_transformers/layers/transformer_model.py \
      spacy_transformers/util.py \
      --replace-fail \
        "from transformers.tokenization_utils import BatchEncoding" \
        "from transformers import BatchEncoding"
  '';

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    numpy
    spacy
    spacy-alignments
    srsly
    torch
    transformers
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
    changelog = "https://github.com/explosion/spacy-transformers/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
