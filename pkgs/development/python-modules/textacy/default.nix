{ lib, buildPythonPackage, fetchPypi, isPy27
, cachetools
, cytoolz
, jellyfish
, matplotlib
, networkx
, numpy
, pyemd
, pyphen
, pytest
, requests
, scikitlearn
, scipy
, spacy
, srsly
}:

buildPythonPackage rec {
  pname = "textacy";
  version = "0.10.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff72adc6dbb85db6981324e226fff77830da57d7fe7e4adb2cafd9dc2a8bfa7d";
  };

  requiredPythonModules = [
    cachetools
    cytoolz
    jellyfish
    matplotlib
    networkx
    numpy
    pyemd
    pyphen
    requests
    scikitlearn
    scipy
    spacy
    srsly
  ];

  checkInputs = [ pytest ];
  # almost all tests have to deal with downloading a dataset, only test pure tests
  checkPhase = ''
    pytest tests/test_text_utils.py \
      tests/test_utils.py \
      tests/preprocessing \
      tests/datasets/test_base_dataset.py
  '';

  meta = with lib; {
    description = "Higher-level text processing, built on spaCy";
    homepage = "https://textacy.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
