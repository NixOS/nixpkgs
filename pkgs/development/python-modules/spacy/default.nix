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
, writeScript
, stdenv
, nix
, git
, nix-update
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IsH/qrKFt0dwA9S1sDhBTMMkaKaQ1HkBW5ppjFMcgTs=";
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
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "typer>=0.3.0,<0.5.0" "typer>=0.3.0"
  '';

  nativeCheckInputs = [
    pytest
  ];

  doCheck = false;
  checkPhase = ''
    ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  '';

  pythonImportsCheck = [
    "spacy"
  ];

  passthru = {
    updateScript = writeScript "update-spacy" ''
    #!${stdenv.shell}
    set -eou pipefail
    PATH=${lib.makeBinPath [ nix git nix-update ]}

    nix-update python3Packages.spacy

    # update spacy models as well
    echo | nix-shell maintainers/scripts/update.nix --argstr package python3Packages.spacy_models.en_core_web_sm
    '';
    tests.annotation = callPackage ./annotation-test { };
  };

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP)";
    homepage = "https://github.com/explosion/spaCy";
    changelog = "https://github.com/explosion/spaCy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
