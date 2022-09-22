{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20220920.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qmutcnsz3utVUmVZZEYYiemOGdQ4Ima2ueD4LyYaOdU=";
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
