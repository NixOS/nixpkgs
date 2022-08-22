{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-redis";
  version = "4.3.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vPLIUsLQ9vmZ8QGAvfytC7+pchdYJs7XCl71i3EAS2w=";
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
