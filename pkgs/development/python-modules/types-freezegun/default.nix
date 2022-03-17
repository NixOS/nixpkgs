{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-freezegun";
  version = "1.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6dEyfpjGyqj2XeABje0nQ0fo40GY1ZqppcJK2SZdXl4=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "freezegun-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for freezegun";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
