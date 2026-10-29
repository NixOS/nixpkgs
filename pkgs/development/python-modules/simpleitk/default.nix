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

buildPythonPackage (finalAttrs: {
  inherit (simpleitk)
    pname
    version
    src
    meta
    ;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/Wrapping/Python";
  preBuild = ''
    make
  '';

  nativeBuildInputs = [
    cmake
    swig
    scikit-build
  ];

  cmakeFlags = [
    "-DSimpleITK_BUILD_DISTRIBUTE=ON"
  ];

  propagatedBuildInputs = [
    elastix
    itk
    simpleitk
    numpy
  ];

  pythonImportsCheck = [ "SimpleITK" ];
})
