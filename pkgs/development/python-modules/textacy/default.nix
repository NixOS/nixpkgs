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
  version = "0.10.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a824333f53d19d24ca864c92da52f3fecd412f4ef3e1448864c45f06189fd6d";
  };

  propagatedBuildInputs = [
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
