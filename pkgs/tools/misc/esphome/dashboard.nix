{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20230120.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xfYwkIklixvo2sCAln7FHL2esPZe+1kmqzOFX1QCG3Y=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "esphome_dashboard"
  ];

  meta = with lib; {
    description = "ESPHome dashboard";
    homepage = "https://esphome.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ hexa ];
  };
}
