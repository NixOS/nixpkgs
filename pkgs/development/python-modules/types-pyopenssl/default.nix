{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "types-pyopenssl";
  version = "24.0.0.20240311";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-pyOpenSSL";
    inherit version;
    hash = "sha256-e8oAz8Tn75xdJmPGocBow1eY5ZZwWVQ59ilue6PVgIM=";
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
