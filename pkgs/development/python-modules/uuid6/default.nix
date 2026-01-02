{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "uuid6";
  version = "2025.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oittaa";
    repo = "uuid6-python";
    tag = version;
    hash = "sha256-E8oBbD52zTDcpRCBsJXfSgpF7FPNSVB43uxvsA62XHU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "uuid6"
  ];

  meta = {
    changelog = "https://github.com/oittaa/uuid6-python/releases/tag/${src.tag}";
    description = "New time-based UUID formats which are suited for use as a database key";
    homepage = "https://github.com/oittaa/uuid6-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
