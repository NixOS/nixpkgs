{ lib
, python3
}:

with python3.pkgs; buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20210719.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gUZut9FsFHZ0zcTg+QDIdsM3EMvNFBawgBnt/Ia1BIc=";
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
