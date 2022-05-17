{ lib
, blis
, buildPythonPackage
, callPackage
, catalogue
, cymem
, fetchPypi
, jinja2
, jsonschema
, langcodes
, murmurhash
, numpy
, packaging
, pathy
, preshed
, pydantic
, pytest
, python
, pythonOlder
, requests
, setuptools
, spacy-legacy
, spacy-loggers
, srsly
, thinc
, tqdm
, typer
, typing-extensions
, wasabi
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xJ1Q++NxWtxXQUGTZ7OaRo0lVmSEIvELb8Tt846uLLM=";
  };

  propagatedBuildInputs = [
    blis
    catalogue
    cymem
    jinja2
    jsonschema
    langcodes
    murmurhash
    numpy
    packaging
    pathy
    preshed
    pydantic
    requests
    setuptools
    spacy-legacy
    spacy-loggers
    srsly
    thinc
    tqdm
    typer
    wasabi
  ] ++ lib.optional (pythonOlder "3.8") [
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pydantic>=1.7.4,!=1.8,!=1.8.1,<1.9.0" "pydantic~=1.2"
  '';

  checkInputs = [
    pytest
  ];

  doCheck = false;
  checkPhase = ''
    ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  '';

  pythonImportsCheck = [
    "spacy"
  ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP)";
    homepage = "https://github.com/explosion/spaCy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
