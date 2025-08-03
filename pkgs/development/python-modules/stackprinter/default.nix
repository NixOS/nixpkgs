{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  numpy,

  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "stackprinter";
  version = "0.2.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cknd";
    repo = "stackprinter";
    tag = version;
    hash = "sha256-Offow68i2Nh65sh5ZowlSdV1SKF2RIfwlRv4z1bCu+k=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "stackprinter"
    "stackprinter.colorschemes"
    "stackprinter.extraction"
    "stackprinter.formatting"
    "stackprinter.frame_formatting"
    "stackprinter.prettyprinting"
    "stackprinter.source_inspection"
    "stackprinter.tracing"
    "stackprinter.utils"
  ];

  meta = {
    description = "Debugging-friendly exceptions for Python";
    homepage = "https://github.com/cknd/stackprinter";
    changelog = "https://github.com/cknd/stackprinter/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
