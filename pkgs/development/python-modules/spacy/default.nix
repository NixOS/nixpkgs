{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

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
  pytest-xdist,
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

buildPythonPackage (finalAttrs: {
  pname = "spacy";
  version = "3.8.16";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spaCy";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-EFzzb9hMBjFh3hD+xId7uxkTVsg92WNiUaCKBRa0bnw=";
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
    pytest-xdist
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
    # ValueError: [E002] Can't find factory for 'assert_sents' for language English (en).
    "test_annotating_components_from_config"

    # touches network
    "test_download_compatibility"
    "test_validate_compatibility_table"
    "test_project_assets"
    "test_find_available_port"

    # Tests for presence of outdated (and thus missing) spacy models
    # https://github.com/explosion/spaCy/issues/13856
    "test_registry_entries"

    # AssertionError: confection has different version in setup.cfg and in requirements.txt:
    # >=1.3.2,<2.0.0 and >=1.1.0,<2.0.0 respectively
    "test_build_dependencies"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # AssertionError:
    #   assert eval["nel_macro_f"] > 0
    #   assert 0.0 > 0
    "test_overfitting_IO_with_ner"
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
    changelog = "https://github.com/explosion/spaCy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
    mainProgram = "spacy";
  };
})
