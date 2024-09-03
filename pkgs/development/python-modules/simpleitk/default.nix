{
  buildPythonPackage,
  pythonOlder,
  cmake,
  swig4,
  elastix,
  itk,
  numpy,
  simpleitk,
  scikit-build,
}:

buildPythonPackage rec {
  inherit (simpleitk)
    pname
    version
    src
    meta
    ;
  format = "pyproject";
  disabled = pythonOlder "3.8";

  sourceRoot = "${src.name}/Wrapping/Python";
  preBuild = ''
    make
  '';

  nativeBuildInputs = [
    cmake
    swig4
    scikit-build
  ];
  propagatedBuildInputs = [
    elastix
    itk
    simpleitk
    numpy
  ];

  pythonImportsCheck = [ "SimpleITK" ];
}
