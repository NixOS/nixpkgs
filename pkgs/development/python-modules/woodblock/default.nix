{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  multimethod,
  numpy,
}:
buildPythonPackage (finalAttrs: {
  pname = "woodblock";
  version = "0.1.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wDR+zpILcAnZRVGYOgH0LbApIMqNew/zbSSjN+LJN/c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    multimethod
    numpy
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "woodblock" ];

  meta = {
    description = "Framework to generate file carving test data";
    mainProgram = "woodblock";
    homepage = "https://github.com/fkie-cad/woodblock";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
