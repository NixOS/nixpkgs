{ lib
, buildPythonPackage
, cachetools
, cytoolz
, fetchPypi
, jellyfish
, joblib
, matplotlib
, networkx
, numpy
, pyemd
, pyphen
, pytestCheckHook
, pythonOlder
, requests
, scikit-learn
, scipy
, spacy
, tqdm
}:

buildPythonPackage rec {
  pname = "textacy";
  version = "0.11.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-d/tyTCewoERA15iBv4H2LORFzgco15fnnN1sneeGuF4=";
  };

  propagatedBuildInputs = [
    cachetools
    cytoolz
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

  checkInputs = [
    pytestCheckHook
  ];

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
    maintainers = with maintainers; [ rvl ];
  };
}
