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
<<<<<<< HEAD
  version = "2.17.1";
=======
  version = "2.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-zfgkTBdE8UWwk+G3bLBThVjgU+m2QoPf1fzORyznEgs=";
=======
    hash = "sha256-ICr/IyzzWX1u4qndZYlPpAMlI3Z1A9povzPseMkIZ4U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/Bluetooth-Devices/sensor-state-data/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
