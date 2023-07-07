{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20230621.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e5nAhtM5Yc2KNmH6a041o6i6SnVCbaONulBe1ZCF0+w=";
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
