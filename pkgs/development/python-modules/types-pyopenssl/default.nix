{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "types-pyopenssl";
  version = "23.3.0.20240106";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-pyOpenSSL";
    inherit version;
    hash = "sha256-PW80Yr7AwmDKrfk/uzdyJcEmZht3nH2auZttrVyhDbk=";
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
