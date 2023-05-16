{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nix
, git
, nix-update
}:

buildPythonPackage rec {
  pname = "spacy";
<<<<<<< HEAD
  version = "3.5.4";
=======
  version = "3.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-mpwWfp3Ov++sx12sNKjnK+y+NI60W78GpsBSOuBaxCU=";
  };

  pythonRelaxDeps = [
    "typer"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

=======
    hash = "sha256-IsH/qrKFt0dwA9S1sDhBTMMkaKaQ1HkBW5ppjFMcgTs=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  ];  postPatch = ''
=======
  ];

  postPatch = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace setup.cfg \
      --replace "typer>=0.3.0,<0.5.0" "typer>=0.3.0"
  '';

  nativeCheckInputs = [
    pytest
  ];

  doCheck = false;
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
