{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20221213.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LwP+LBHzEWjPUih6aaZnI7Yh85vsa1Md1YgBWkLOUIs=";
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
