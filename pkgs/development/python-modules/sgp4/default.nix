{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "sgp4";
  version = "2.26";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SNFXY7avk5P8ICQZBwVYjdNlD82QEzq5gOALxWB8YG4=";
  };

  nativeCheckInputs = [ numpy ];

  pythonImportsCheck = [ "sgp4" ];

  meta = {
    homepage = "https://github.com/brandon-rhodes/python-sgp4";
    description = "Python version of the SGP4 satellite position library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zane ];
  };
}
