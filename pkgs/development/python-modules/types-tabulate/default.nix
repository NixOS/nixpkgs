{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.9.0.20240106";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ybbbEN1/z1W9FxLdNTf4bdznKgj9Yrsa9DOMcJbOlH4=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "tabulate-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for tabulate";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
