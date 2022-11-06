{ lib
, buildPythonPackage
, fetchFromGitHub
, home-assistant-bluetooth
, poetry-core
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "sensor-state-data";
  version = "2.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-znDEdXCWYmzk5xG1sSUyXRUhLGxtoBv46JcSnysu1A4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=sensor_state_data --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "sensor_state_data"
  ];

  meta = with lib; {
    description = "Models for storing and converting Sensor Data state";
    homepage = "https://github.com/bluetooth-devices/sensor-state-data";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
