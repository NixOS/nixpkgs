{ lib
, blis
, buildPythonPackage
, callPackage
, catalogue
, cymem
, fetchPypi
, jinja2
, jsonschema
, murmurhash
, numpy
, packaging
, pathy
, preshed
, pydantic
, pytest
, pythonOlder
, requests
, setuptools
, spacy-legacy
, srsly
, thinc
, tqdm
, typer
, typing-extensions
, wasabi
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.1.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18n200hjdz6jlixx214xwyxwaj611srsn64glhp1k5vrl9j4w22q";
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
    spacy-legacy
    srsly
    thinc
    tqdm
    typer
    wasabi
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

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
      --replace "pydantic>=1.7.4,!=1.8,!=1.8.1,<1.9.0" "pydantic<1.9.0"
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
