{
  buildPythonPackage,
  cmake,
  swig,
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
  pyproject = true;

  sourceRoot = "${src.name}/Wrapping/Python";
  preBuild = ''
    make
  '';

  nativeBuildInputs = [
    cmake
    swig
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
