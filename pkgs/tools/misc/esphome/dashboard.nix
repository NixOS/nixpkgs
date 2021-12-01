{ lib
, python3
}:

with python3.pkgs; buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20211201.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/VARM59TI2Ff70Jq0smFMrt4o2G/wKSdcOreLfxMAMQ=";
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
