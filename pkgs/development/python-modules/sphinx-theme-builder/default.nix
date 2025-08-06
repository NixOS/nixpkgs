{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  nodeenv,
  packaging,
  pyproject-metadata,
  rich,
  setuptools,
  tomli,
  typing-extensions,
  build,
  click,
  sphinx-autobuild,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-theme-builder";
  version = "0.2.0b2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-theme-builder";
    rev = version;
    hash = "sha256-ycOXHE+9v2NmoOjW11bXJ4U2AOfaRk9hdiJugW4NWFg=";
  };

  postPatch = ''
    # removed in click 8.2
    substituteInPlace tests/conftest.py \
      --replace-fail "mix_stderr=False" ""
  '';

  build-system = [
    flit-core
  ];

  dependencies = [
    nodeenv
    packaging
    pyproject-metadata
    rich
    setuptools
    tomli
    typing-extensions
  ];

  optional-dependencies = {
    cli = [
      build
      click
      sphinx-autobuild
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.cli;

  disabledTests = [
    "test_no_arguments"
    "test_no_arguments_behaves_same_as_help"
  ];

  pythonImportsCheck = [
    "sphinx_theme_builder"
  ];

  meta = {
    description = "Streamline the Sphinx theme development workflow.";
    homepage = "https://github.com/pradyunsg/sphinx-theme-builder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
