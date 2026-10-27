{
  buildPythonPackage,
  cython,
  setuptools,
  numpy,
  matplotlib,
  scipy,
  pkgs,
}:
buildPythonPackage (finalAttrs: {
  inherit (pkgs.toppra) pname version src;

  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    numpy
    matplotlib
    scipy
  ];

  pythonImportsCheck = [
    "toppra"
  ];

  meta = {
    inherit (pkgs.toppra.meta)
      changelog
      description
      homepage
      license
      maintainers
      platforms
      ;
  };
})
