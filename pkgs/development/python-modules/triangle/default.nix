{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  #pytestCheckHook,
  cython,
  setuptools,
  numpy,
}:

buildPythonPackage rec {
  pname = "triangle";
  version = "20230923";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "drufat";
    repo = "triangle";
    rev = "v${version}";
    hash = "sha256-S324XlaDHcXRFK0Gcm1UuS0phb2hOpuYGcw3YFs7i6I=";
    fetchSubmodules = true;
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    # TODO: tests work outside of the package
    # but importing the binary module fails while in pytestCheckHook
    #pytestCheckHook
  ];
  pythonImportsCheck = [
    "triangle"
    "triangle.core" # binary submodule
    "triangle.version" # python submodule
  ];

  meta = {
    description = "Python bindings to the triangle library";
    homepage = "https://github.com/drufat/triangle";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
