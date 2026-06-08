{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "trsfile";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "Keysight";
    repo = "python-trsfile";
    rev = version;
    hash = "sha256-mY4L1FFg2wDWAGVadOca7GDffA05O3v317SCqHxt4F0=";
  };

  pyproject = true;

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "trsfile"
  ];

  meta = with lib; {
    description = "Python library for reading/writing .trs files used by Riscure Inspector";
    homepage = "https://github.com/Keysight/python-trsfile";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ mach ];
  };
}
