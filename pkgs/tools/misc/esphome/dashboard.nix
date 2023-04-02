{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20230214.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TfQIvvLLsYubLbai2RNJkCu96nYFEWbdZU8WaJbpUwU=";
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
