{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pycryptodome
}:

buildPythonPackage rec {
  pname = "temescal";
  version = "0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V1wsncIm4f6NPa6lwlO9pkDIFBG1K3VhmOQCwyrPGm4=";
  };

  propagatedBuildInputs = [
    pycryptodome
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "temescal"
  ];

  meta = with lib; {
    description = "Module for interacting with LG speaker systems";
    homepage = "https://github.com/google/python-temescal";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
