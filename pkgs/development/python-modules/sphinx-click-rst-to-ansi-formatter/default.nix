{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  click,
  colorama,
  docutils,
  nix-update-script,
}:

buildPythonPackage {
  pname = "sphinx-click-rst-to-ansi-formatter";
  version = "0-unstable-2024-09-28";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hakonhagland";
    repo = "sphinx-click-rst-to-ansi-formatter";
    rev = "9297db8e6f1575c64ead1bd2551dad09d79f79b5";
    hash = "sha256-3B46V0VM5kHNULsIe3aaNP8dbBA48P4ll0BQ/aKZGJM=";
  };

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  dependencies = [
    click
    colorama
    docutils
  ];

  pythonRelaxDeps = [
    "docutils"
  ];

  pythonImportsCheck = [
    "sphinx_click.rst_to_ansi_formatter"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "";
    homepage = "https://github.com/hakonhagland/sphinx-click-rst-to-ansi-formatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
