{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+25tIa07AbGHj8an0/Jm0fhFiwE9cUWTO9kI6x5mj7I=";
  };

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
