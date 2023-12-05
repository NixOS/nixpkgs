{ lib
, buildPythonPackage
, fetchPypi

# build-system
, scikit-build-core
, cmake
, pathspec
, ninja
, pyproject-metadata

# dependencies
, numpy

# tests
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "spglib";
  version = "2.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gUNUX9/8EfvNpNcFpra81Iid6bw1JLeN+GajbdDeCks=";
  };

  nativeBuildInputs = [
    scikit-build-core
    cmake
    pathspec
    ninja
    pyproject-metadata
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
