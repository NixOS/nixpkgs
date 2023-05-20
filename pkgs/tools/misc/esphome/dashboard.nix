{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20230516.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mkh31ip7xzG8e4qgIVc+HFN310SnuTGRp4HYbFqKa/A=";
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
