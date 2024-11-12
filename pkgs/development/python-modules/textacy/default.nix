{
  lib,
  buildPythonPackage,
  cachetools,
  cytoolz,
  fetchPypi,
  floret,
  jellyfish,
  joblib,
  matplotlib,
  networkx,
  numpy,
  pyemd,
  pyphen,
  pytestCheckHook,
  pythonOlder,
  requests,
  scikit-learn,
  scipy,
  spacy,
  tqdm,
}:

buildPythonPackage rec {
  pname = "textacy";
  version = "0.13.0";
  disabled = pythonOlder "3.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a+AkSMCPx9fE7fhSiQBuOaSlPvdHIB/yS2dcZS9AxoY=";
  };

  propagatedBuildInputs = [
    cachetools
    cytoolz
    floret
    jellyfish
    joblib
    matplotlib
    networkx
    numpy
    pyemd
    pyphen
    requests
    scikit-learn
    scipy
    spacy
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # Almost all tests have to deal with downloading a dataset, only test pure tests
    "tests/test_constants.py"
    "tests/preprocessing/test_normalize.py"
    "tests/similarity/test_edits.py"
    "tests/preprocessing/test_resources.py"
    "tests/preprocessing/test_replace.py"
  ];

  pythonImportsCheck = [ "textacy" ];

  meta = with lib; {
    description = "Higher-level text processing, built on spaCy";
    homepage = "https://textacy.readthedocs.io/";
    license = licenses.asl20;
  };
}
