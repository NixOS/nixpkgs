{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "types-pyopenssl";
  version = "24.0.0.20240228";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-pyOpenSSL";
    inherit version;
    hash = "sha256-zZkHF9iqN0PvDnPg9GLmS1TZDDBCSSMtSP7OTw98PGo=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "OpenSSL-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for pyopenssl";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ gador ];
  };
}
