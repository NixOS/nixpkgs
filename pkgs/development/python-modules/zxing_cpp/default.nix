{ lib
, buildPythonPackage
, cmake
, numpy
, pillow
, pybind11
, zxing-cpp
}:

buildPythonPackage rec {
  pname = "zxing_cpp";
  inherit (zxing-cpp) src version meta;

  sourceRoot = "${src.name}/wrappers/python";

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    pybind11
    numpy
  ];

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
    pillow
  ];
}
