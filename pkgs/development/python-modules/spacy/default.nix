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
, spacy-loggers
, langcodes
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.2.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9uusURYndAqMorEXuR71UVyPCy+xF6aevgHQEN1PxTw=";
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
    spacy-loggers
    langcodes
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
