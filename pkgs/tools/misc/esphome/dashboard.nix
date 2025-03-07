{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20240620.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "esphome_dashboard";
    inherit version;
    hash = "sha256-lx3i8Z2PUefyibCNiQ4zPEwfgXr6r/TVa9TBF0YE5fA=";
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
