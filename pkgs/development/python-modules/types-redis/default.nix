{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-redis";
  version = "4.3.20";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dO0ClFRw3eot0hRHwYXauzFp5aUyjSayXPNUfZSbjgQ=";
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
