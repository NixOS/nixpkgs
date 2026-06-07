{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "temescal";
  version = "0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MfTftheNj8zI3iXIIJU+jy9xikvX9eO58LA0NCMJBnY=";
  };

  propagatedBuildInputs = [ pycryptodome ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "temescal" ];

  meta = {
    description = "Module for interacting with LG speaker systems";
    homepage = "https://github.com/google/python-temescal";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
