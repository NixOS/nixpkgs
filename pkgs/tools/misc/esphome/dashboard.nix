{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20221109.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9LL/tO40Mr4PGojj50m4UIPoqImnDRNoVPqr8xXs6KU=";
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
