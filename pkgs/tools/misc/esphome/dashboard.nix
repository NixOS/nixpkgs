{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20221020.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K65eeiGchdzxx5MIR+QhUd0PzQTQBwNX4P8dqTOM1MY=";
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
