{ lib
, buildPythonPackage
, cmake
, setuptools-scm
, numpy
, pillow
, pybind11
, libzxing-cpp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zxing-cpp";
  inherit (libzxing-cpp) src version meta;
  pyproject = true;

  sourceRoot = "${src.name}/wrappers/python";

  # we don't need pybind11 in the root environment
  # https://pybind11.readthedocs.io/en/stable/installing.html#include-with-pypi
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "pybind11[global]" "pybind11"
  '';

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    numpy
  ];

  buildInputs = [
    pybind11
  ];

  nativeBuildInputs = [
    cmake
    setuptools-scm
  ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  pythonImportsCheck = [
    "zxingcpp"
  ];
}
