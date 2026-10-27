{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "sgp4";
  version = "2.27";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BtNyR8aYVzm3B7izm2uD4G6K94OyUx4xllUBupg5hfk=";
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
