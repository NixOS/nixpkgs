{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cymem,
  cython,
  murmurhash,
  numpy,
  preshed,
  thinc,

  # dependencies
  catalogue,
  jinja2,
  langcodes,
  packaging,
  pydantic,
  requests,
  setuptools,
  spacy-legacy,
  spacy-loggers,
  srsly,
  tqdm,
  typer,
  wasabi,
  weasel,

  # optional-dependencies
  spacy-transformers,
  spacy-lookups-data,

  # tests
  pytestCheckHook,
  hypothesis,
  mock,

  # passthru
  writeScript,
  git,
  nix,
  nix-update,
  callPackage,
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.8.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spaCy";
    tag = "release-v${version}";
    hash = "sha256-mRra5/4W3DFVI/KbReTg2Ey9mOC6eQQ31/QDt7Pw0fU=";
  };

  build-system = [
    cymem
    cython
    murmurhash
    numpy
    preshed
    thinc
  ];

  pythonRelaxDeps = [ "thinc" ];

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

  optional-dependencies = {
    transformers = [ spacy-transformers ];
    lookups = [ spacy-lookups-data ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    mock
  ];

  # Fixes ModuleNotFoundError when running tests on Cythonized code. See #255262
  preCheck = ''
    cd $out
  '';

  disabledTestMarks = [ "slow" ];

  disabledTests = [
    # touches network
    "test_download_compatibility"
    "test_validate_compatibility_table"
    "test_project_assets"
    "test_find_available_port"

    # Tests for presence of outdated (and thus missing) spacy models
    # https://github.com/explosion/spaCy/issues/13856
    "test_registry_entries"
  ];

  pythonImportsCheck = [ "spacy" ];

  passthru = {
    updateScript = writeScript "update-spacy" ''
      #!${stdenv.shell}
      set -eou pipefail
      PATH=${
        lib.makeBinPath [
          git
          nix
          nix-update
        ]
      }

      nix-update python3Packages.spacy --version-regex 'release-v([0-9.]+)'

      # update spacy models as well
      echo | nix-shell maintainers/scripts/update.nix --argstr package python3Packages.spacy-models.en_core_web_sm
    '';
    tests.annotation = callPackage ./annotation-test { };
  };

  __darwinAllowLocalNetworking = true; # needed for test_find_available_port

  meta = {
    description = "Industrial-strength Natural Language Processing (NLP)";
    homepage = "https://github.com/explosion/spaCy";
    changelog = "https://github.com/explosion/spaCy/releases/tag/release-v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
    mainProgram = "spacy";
  };
}
