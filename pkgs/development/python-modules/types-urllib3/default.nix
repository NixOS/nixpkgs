{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-urllib3";
  version = "1.26.24";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-obOq6n3aPrG1Fpnucjqt0jVIjk3EZI4DDwm8Qp7P9C8=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "urllib3-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for urllib3";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
