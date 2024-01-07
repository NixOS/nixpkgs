{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.9.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GXZR+dZGcZPNFm2FABFqbTom8qTrLbCTvJU17hwL5V4=";
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
