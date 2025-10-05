{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scipy,
  spglib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "symfc";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symfc";
    repo = "symfc";
    tag = "v${version}";
    hash = "sha256-SGFKbOVi5cVw+8trXrSnO0v2obpJBZrj+7yXk7hK+1s=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    spglib
  ];

  pythonImportsCheck = [
    "symfc"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Generate symmetrized force constants";
    homepage = "https://github.com/symfc/symfc";
    changelog = "https://github.com/symfc/symfc/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
