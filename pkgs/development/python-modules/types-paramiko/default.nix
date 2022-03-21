{ lib
, buildPythonPackage
, fetchPypi
, types-cryptography
}:

buildPythonPackage rec {
  pname = "types-paramiko";
  version = "2.8.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1toFPkau9cYpvE6lvatWZwhlNerg/P2N6EBpQ7g00uY=";
  };

  pythonImportsCheck = [
    "paramiko-stubs"
  ];

  propagatedBuildInputs = [ types-cryptography ];

  meta = with lib; {
    description = "Typing stubs for paramiko";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
