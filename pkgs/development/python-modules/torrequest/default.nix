{ lib, buildPythonPackage, fetchPypi, requests, pysocks, stem }:

buildPythonPackage rec {
  pname = "torrequest";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N0XU6j/9qY16A0Njx4ets3qrd72rQAlKTZNzks1NroI=";
  };

  propagatedBuildInputs = [
    pysocks requests stem
  ];

  # This package does not contain any tests.
  doCheck = false;

  pythonImportsCheck = [
    "torrequest"
  ];

  meta = with lib; {
    homepage = "https://github.com/erdiaker/torrequest";
    description = "Simple Python interface for HTTP(s) requests over Tor";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ applePrincess ];
  };
}
