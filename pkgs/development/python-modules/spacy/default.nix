{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  catalogue,
  cymem,
  cython_0,
  fetchPypi,
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
  pythonOlder,
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
  version = "3.8.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-galn3D1qWgqaslBVlIP+IJIwZYKpGS+Yvnpjvc4nl/c=";
  };

  postPatch = ''
    # unpin numpy, cannot use pythonRelaxDeps because it's in build-system
    substituteInPlace pyproject.toml setup.cfg \
      --replace-fail ",<2.1.0" ""
  '';

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

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP)";
    homepage = "https://github.com/explosion/spaCy";
    changelog = "https://github.com/explosion/spaCy/releases/tag/release-v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "spacy";
  };
}
