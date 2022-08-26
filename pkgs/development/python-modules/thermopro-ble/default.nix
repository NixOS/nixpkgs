{ lib
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "thermopro-ble";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YVSJG+H4kUMrsVUBNjW67V2s/ziYH6RzQIk6CvMfRfg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=thermopro_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "thermopro_ble"
  ];

  meta = with lib; {
    description = "Library for Thermopro BLE devices";
    homepage = "https://github.com/bluetooth-devices/thermopro-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
