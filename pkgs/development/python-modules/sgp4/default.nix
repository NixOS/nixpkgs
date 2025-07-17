{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "sgp4";
  version = "2.24";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VlUknyduoj+9rp6IGrAdgkIChbRdx20NpPQk42R/g1I=";
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
