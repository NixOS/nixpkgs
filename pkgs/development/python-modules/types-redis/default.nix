{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, types-pyopenssl
}:

buildPythonPackage rec {
  pname = "types-redis";
  version = "4.6.0.20240218";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UQPX5pDlx0yXShYTF7LVmsIwPPi+8kF1sEwqTDSGyzk=";
  };

  propagatedBuildInputs = [
    cryptography
    types-pyopenssl
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "redis-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for redis";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ gador ];
  };
}
