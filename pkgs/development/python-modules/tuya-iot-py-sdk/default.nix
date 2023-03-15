{ lib
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pycryptodome
, pythonOlder
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "tuya-iot-py-sdk";
  version = "0.6.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tuya";
    repo = "tuya-iot-python-sdk";
    rev = "v${version}";
    hash = "sha256-KmSVa71CM/kNhzE4GznaxISGmIaV+UcTSn3v+fmxmrQ=";
  };

  propagatedBuildInputs = [
    paho-mqtt
    pycryptodome
    requests
    websocket-client
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "tuya_iot" ];

  meta = with lib; {
    description = "Tuya IoT Python SDK for Tuya Open API";
    homepage = "https://github.com/tuya/tuya-iot-python-sdk";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
