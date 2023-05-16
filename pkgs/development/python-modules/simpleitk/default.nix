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

<<<<<<< HEAD
  sourceRoot = "${src.name}/Wrapping/Python";
=======
  sourceRoot = "source/Wrapping/Python";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preBuild = ''
    make
  '';

  nativeBuildInputs = [ cmake swig4 scikit-build ];
  propagatedBuildInputs = [ itk simpleitk numpy ];

  pythonImportsCheck = [ "SimpleITK" ];
}
