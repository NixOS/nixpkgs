{ lib
, python3
}:

with python3.pkgs; buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20210728.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OmlMrPLFMIV0Nu3aEKFotFXCZ2RKH9wYaev0SKvMBfQ=";
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
