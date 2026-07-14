{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cachetools,
  cytoolz,
  fetchPypi,
  floret,
  jellyfish,
  joblib,
  matplotlib,
  networkx,
  numpy,
  pyphen,
  pytestCheckHook,
  requests,
  scikit-learn,
  scipy,
  spacy,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "textacy";
  version = "0.13.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chartbeat-labs";
    repo = "textacy";
    tag = finalAttrs.version;
    hash = "sha256-QVxC9oV1X5ifQ9VVYissppni1A8LACz/FVgaoG5/GFU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    cytoolz
    floret
    jellyfish
    joblib
    networkx
    numpy
    pyphen
    requests
    scikit-learn
    scipy
    spacy
    tqdm
  ];

  optional-dependencies = {
    vis = [ matplotlib ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [
    # Almost all tests have to deal with downloading a dataset, only test pure tests
    "tests/test_constants.py"
    "tests/preprocessing/test_normalize.py"
    "tests/similarity/test_edits.py"
    "tests/preprocessing/test_resources.py"
    "tests/preprocessing/test_replace.py"
  ];

  pythonImportsCheck = [ "textacy" ];

  meta = {
    description = "Higher-level text processing, built on spaCy";
    homepage = "https://textacy.readthedocs.io/";
    changelog = "https://github.com/chartbeat-labs/textacy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
