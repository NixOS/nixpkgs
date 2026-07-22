{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "trsfile";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "Keysight";
    repo = "python-trsfile";
    tag = finalAttrs.version;
    hash = "sha256-c56DvBezOPOTBoNnnP0NnpeKv5Gmf6usGrLwI4Qm3As=";
  };

  pyproject = true;

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

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

  meta = {
    description = "Python library for reading/writing .trs files used by Riscure Inspector";
    homepage = "https://github.com/Keysight/python-trsfile";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mach ];
  };
})
