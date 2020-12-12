{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pythonOlder
, pytest
, blis
, catalogue
, cymem
, jsonschema
, murmurhash
, numpy
, pathlib
, plac
, preshed
, requests
, setuptools
, srsly
, thinc
, wasabi
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "315278ab60094643baecd866017c7d4cbd966efd2d517ad0e6c888edf7fa5aef";
  };

  propagatedBuildInputs = [
    blis
    catalogue
    cymem
    jsonschema
    murmurhash
    numpy
    plac
    preshed
    requests
    setuptools
    srsly
    thinc
    wasabi
  ] ++ lib.optional (pythonOlder "3.4") pathlib;

  checkInputs = [
    pytest
  ];

  doCheck = false;
  # checkPhase = ''
  #   ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  # '';

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "blis>=0.4.0,<0.8.0" "blis>=0.4.0,<1.0" \
      --replace "catalogue>=0.0.7,<1.1.0" "catalogue>=0.0.7,<3.0" \
      --replace "plac>=0.9.6,<1.2.0" "plac>=0.9.6,<2.0" \
      --replace "srsly>=1.0.2,<1.1.0" "srsly>=1.0.2,<3.0" \
      --replace "thinc>=7.4.1,<7.5.0" "thinc>=7.4.1,<8"
  '';

  pythonImportsCheck = [ "spacy" ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
    homepage = "https://github.com/explosion/spaCy";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk sdll ];
  };
}
