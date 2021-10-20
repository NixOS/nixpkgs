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
, python
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.1.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WAhOZKJ5lxkupI8Yq7MOwUjFu+edBNF7pNL8JiEAwqI=";
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
