{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  catalogue,
  cymem,
  cython_0,
  fetchPypi,
  hypothesis,
  jinja2,
  langcodes,
  mock,
  murmurhash,
  numpy,
  packaging,
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
  wasabi,
  weasel,
  writeScript,
  nix,
  git,
  nix-update,
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.7.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9AZcCqxcSLv7L/4ZHVXMszv7AFN2r71MzW1ek0FRTjQ=";
  };

  postPatch = ''
    # thinc version 8.3.0 had no functional changes
    # also see https://github.com/explosion/spaCy/issues/13607
    substituteInPlace pyproject.toml setup.cfg \
      --replace-fail "thinc>=8.2.2,<8.3.0" "thinc>=8.2.2,<8.4.0"
  '';

  build-system = [
    cymem
    cython_0
    murmurhash
    numpy
    thinc
  ];

  dependencies = [
    catalogue
    cymem
    jinja2
    langcodes
    murmurhash
    numpy
    packaging
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    mock
  ];

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
    changelog = "https://github.com/explosion/spaCy/releases/tag/release-v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
