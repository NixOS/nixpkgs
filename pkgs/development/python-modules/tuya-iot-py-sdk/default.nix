{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pycryptodome,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "tuya-iot-py-sdk";
  version = "0.6.6";
  format = "setuptools";

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

  meta = {
    description = "Tuya IoT Python SDK for Tuya Open API";
    homepage = "https://github.com/tuya/tuya-iot-python-sdk";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
