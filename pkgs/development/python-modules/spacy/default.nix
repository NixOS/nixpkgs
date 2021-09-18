{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pythonOlder
, pytest
, blis
, catalogue
, cymem
, jinja2
, jsonschema
, murmurhash
, numpy
, pathlib
, preshed
, requests
, setuptools
, srsly
, spacy-legacy
, thinc
, typer
, wasabi
, packaging
, pathy
, pydantic
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.0.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ViirifH1aAmciAsSqcN/Ts4pq4kmBmDP33KMAnEYecU=";
  };

  propagatedBuildInputs = [
    blis
    catalogue
    cymem
    jinja2
    jsonschema
    murmurhash
    numpy
    preshed
    requests
    setuptools
    srsly
    spacy-legacy
    thinc
    wasabi
    packaging
    pathy
    pydantic
    typer
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
      --replace "pydantic>=1.7.1,<1.8.0" "pydantic>=1.7.1,<1.8.3"
  '';

  pythonImportsCheck = [ "spacy" ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
    homepage = "https://github.com/explosion/spaCy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
