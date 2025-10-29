{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hjson,
  pytestCheckHook,
  rich,
}:

buildPythonPackage rec {
  pname = "super-collections";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "super-collections";
    tag = "v${version}";
    hash = "sha256-gp5BREoa1oHGm1ymDlIdlLTqyIvB0RmkNLYDJssI3VE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    hjson
  ];

  nativeCheckInputs = [
    pytestCheckHook
    rich
  ];

  pythonImportsCheck = [
    "super_collections"
  ];

  meta = {
    description = "Python SuperDictionaries (with attributes) and SuperLists";
    homepage = "https://github.com/fralau/super-collections";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
