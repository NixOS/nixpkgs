{
  lib,
  stdenv,
  blis,
  buildPythonPackage,
  callPackage,
  catalogue,
  cymem,
  cython_0,
  fetchPypi,
  hypothesis,
  jinja2,
  jsonschema,
  langcodes,
  mock,
  murmurhash,
  numpy,
  packaging,
  pathy,
  preshed,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  spacy-legacy,
  spacy-loggers,
  srsly,
  thinc,
  tqdm,
  typer,
  typing-extensions,
  wasabi,
  weasel,
  writeScript,
  nix,
  git,
  nix-update,
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.7.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pkjGy/Ksx6Vaae6ef6TyK99pqoKKWHobxc//CM88LdM=";
  };

  pythonRelaxDeps = [
    "smart-open"
    "typer"
  ];

  nativeBuildInputs = [
    cython_0
  ];

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
    weasel
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    mock
  ];

  doCheck = true;

  # Fixes ModuleNotFoundError when running tests on Cythonized code. See #255262
  preCheck = ''
    cd $out
  '';

  pytestFlagsArray = [ "-m 'slow'" ];

  disabledTests = [
    # touches network
    "test_download_compatibility"
    "test_validate_compatibility_table"
    "test_project_assets"
  ];

  pythonImportsCheck = [ "spacy" ];

  passthru = {
    updateScript = writeScript "update-spacy" ''
      #!${stdenv.shell}
      set -eou pipefail
      PATH=${
        lib.makeBinPath [
          nix
          git
          nix-update
        ]
      }

      nix-update python3Packages.spacy

      # update spacy models as well
      echo | nix-shell maintainers/scripts/update.nix --argstr package python3Packages.spacy-models.en_core_web_sm
    '';
    tests.annotation = callPackage ./annotation-test { };
  };

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP)";
    mainProgram = "spacy";
    homepage = "https://github.com/explosion/spaCy";
    changelog = "https://github.com/explosion/spaCy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
