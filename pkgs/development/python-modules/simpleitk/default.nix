{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, swig4
, itk
, numpy
, simpleitk
, scikit-build
}:

buildPythonPackage rec {
  inherit (simpleitk) pname version src meta;
  format = "pyproject";
  disabled = pythonOlder "3.8";

  sourceRoot = "source/Wrapping/Python";
  preBuild = ''
    make
  '';

  nativeBuildInputs = [ cmake swig4 scikit-build ];
  propagatedBuildInputs = [ itk simpleitk numpy ];

  pythonImportsCheck = [ "SimpleITK" ];
}
