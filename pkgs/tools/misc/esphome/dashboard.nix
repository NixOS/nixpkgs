{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20240319.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jiEXZWw8A4RcsRbypFpWkt8O3Ib1cNcOQO1zHt96aQU=";
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
