{ lib
, python3
}:

with python3.pkgs; buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20210615.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07ammr46bipfi4b7nnjkip5l7966wxqhp5n3g2wqf68m3ymx24s9";
  };

  meta = with lib; {
    description = "ESPHome dashboard";
    homepage = "https://esphome.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ hexa ];
  };
}
