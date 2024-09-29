{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  numpy,
  jsonschema,
  svgwrite,
}:

buildPythonPackage rec {
  pname = "tskit";
  version = "0.5.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wq7ar96w5hdAyKMMvK4zjYln74RmX1l/VhvS++CN+Xk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    numpy
    svgwrite
  ];

  # Pypi does not include test folder and too complex to compile from GitHub source
  # will ask upstream to include tests in pypi
  doCheck = false;

  pythonImportsCheck = [ "tskit" ];

  meta = {
    description = "Tree sequence toolkit";
    mainProgram = "tskit";
    homepage = "https://github.com/tskit-dev/tskit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alxsimon ];
  };
}
