{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-freezegun";
  version = "1.1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yzotLu6VDqy6rAZzq1BJmCM2XOuMZVursVRKQURkCew=";
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
