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
, python
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.2.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "68e54b2a14ce74eeecea9bfb0b9bdadf8a4a8157765dbefa7e50d25a1bf0f2f3";
  };

  propagatedBuildInputs = [
    blis
    catalogue
    cymem
    jinja2
    jsonschema
    murmurhash
    numpy
    packaging
    pathy
    preshed
    pydantic
    requests
    setuptools
    srsly
    spacy-legacy
    thinc
    tqdm
    typer
    wasabi
  ] ++ lib.optional (pythonOlder "3.8") typing-extensions;

  checkInputs = [
    pytest
  ];

  doCheck = false;
  checkPhase = ''
    ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
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
