{ lib
, python3
}:

with python3.pkgs; buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20210622.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00qndincn8m7ap6ficsrl7vlr4dwb9q9ybjyj947r1fwprnbbj0l";
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
