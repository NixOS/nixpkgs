{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20240412.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MT/EpZ8kDKHhJGF4njdh6Q+xe8GF4FYxaoIighSguiQ=";
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
