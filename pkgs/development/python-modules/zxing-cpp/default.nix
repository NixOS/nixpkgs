{ lib
, buildPythonPackage
, cmake
, numpy
, pillow
, pybind11
, libzxing-cpp
}:

buildPythonPackage rec {
  pname = "zxing-cpp";
  inherit (libzxing-cpp) src version meta;

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
