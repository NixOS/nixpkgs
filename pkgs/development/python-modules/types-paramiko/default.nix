{ lib
, buildPythonPackage
, fetchPypi
, types-cryptography
}:

buildPythonPackage rec {
  pname = "types-paramiko";
  version = "2.8.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZAyFCsqK3EGw1aIl7jaseBJonhpDcMMS+OS5Ks7I5AU=";
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
