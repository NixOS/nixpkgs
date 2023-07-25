{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "types-pyopenssl";
  version = "23.2.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-pyOpenSSL";
    inherit version;
    hash = "sha256-vutdInBMYloeS23HVjVcW0rwuYATi3AqnZ+TKs8CCQM=";
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
