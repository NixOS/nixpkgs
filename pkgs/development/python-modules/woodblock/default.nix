{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  multimethod,
  numpy,
}:
buildPythonPackage rec {
  pname = "woodblock";
  version = "0.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wDR+zpILcAnZRVGYOgH0LbApIMqNew/zbSSjN+LJN/c=";
  };

  propagatedBuildInputs = [
    click
    multimethod
    numpy
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "woodblock" ];

  meta = with lib; {
    description = "Framework to generate file carving test data";
    mainProgram = "woodblock";
    homepage = "https://github.com/fkie-cad/woodblock";
    license = licenses.mit;
    maintainers = [ ];
  };
}
