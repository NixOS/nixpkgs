{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.9.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SnlHRxTOoVa80hhbub3dj7nT1SJ8jQp/Ib8hyvX2Dmc=";
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
