{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  catalogue,
  cymem,
  cython_0,
  fetchFromGitHub,
  git,
  hypothesis,
  jinja2,
  langcodes,
  mock,
  murmurhash,
  nix-update,
  nix,
  numpy,
  packaging,
  preshed,
  pydantic,
  pytestCheckHook,
  requests,
  setuptools,
  spacy-legacy,
  spacy-loggers,
  spacy-lookups-data,
  spacy-transformers,
  srsly,
  thinc,
  tqdm,
  typer,
  wasabi,
  weasel,
  writeScript,
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "3.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spaCy";
    tag = "release-v${version}";
    hash = "sha256-rgMstGSscUBACA5+veXD9H/lHuvWKs7hJ6hz6aKOB/0=";
  };

  build-system = [
    cymem
    cython_0
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

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    mock
  ];

  optional-dependencies = {
    transformers = [ spacy-transformers ];
    lookups = [ spacy-lookups-data ];
  };

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

  meta = {
    description = "Industrial-strength Natural Language Processing (NLP)";
    homepage = "https://github.com/explosion/spaCy";
    changelog = "https://github.com/explosion/spaCy/releases/tag/release-v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "spacy";
  };
}
