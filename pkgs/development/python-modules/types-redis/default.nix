{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-redis";
  version = "4.3.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uDNKlqL0MVIb+nIgWzQxKazcWmRv/PswTYChzQ3v9Ug=";
  };

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
