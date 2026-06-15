{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  multimethod,
  numpy,
}:
buildPythonPackage rec {
  pname = "woodblock";
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0347ece920b7009d94551983a01f42db02920ca8d7b0ff36d24a337e2c937f7";
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
}
