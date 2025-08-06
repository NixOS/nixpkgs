{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "sgp4";
  version = "2.25";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4Z7cbcwl1p+4/eCiZ7jwxE1+kVx7y+rPXTqLWVuvBnQ=";
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
