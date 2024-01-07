{ lib, buildPythonPackage, fetchPypi, numpy }:

buildPythonPackage rec {
  pname = "sgp4";
  version = "2.23";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2K3cU6L7n4je5r/UAdKGWwFMwLV78s7mm97o2WhdVCk=";
  };

  nativeCheckInputs = [ numpy ];

  pythonImportsCheck = [ "sgp4" ];

  meta = with lib; {
    homepage = "https://github.com/brandon-rhodes/python-sgp4";
    description = "Python version of the SGP4 satellite position library";
    license = licenses.mit;
    maintainers = with maintainers; [ zane ];
  };
}
