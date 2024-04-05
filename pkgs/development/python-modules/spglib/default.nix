{ lib
, buildPythonPackage
, fetchPypi

# build-system
, scikit-build-core
, cmake
, pathspec
, ninja
, pyproject-metadata
, setuptools-scm

# dependencies
, numpy

# tests
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "spglib";
  version = "2.3.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c24l7GfCIMsg+rcBfE/mOC7t7iIwdtV/QEc0KxvGjOM=";
  };

  nativeBuildInputs = [
    scikit-build-core
    cmake
    pathspec
    ninja
    pyproject-metadata
    setuptools-scm
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [
    "spglib"
  ];

  meta = with lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
