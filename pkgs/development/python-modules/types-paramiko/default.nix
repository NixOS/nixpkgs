{ lib
, buildPythonPackage
, fetchPypi
, types-cryptography
}:

buildPythonPackage rec {
  pname = "types-paramiko";
  version = "2.8.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tsK0nbyjv6hlONLinKRAgckjECEIqrGsK0f1OL5h5S4=";
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
