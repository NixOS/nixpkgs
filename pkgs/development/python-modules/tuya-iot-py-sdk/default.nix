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
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tuya";
    repo = "tuya-iot-python-sdk";
    rev = "v${version}";
    sha256 = "1qfjq4h62phsrmrfb11xwd6gjc28vhs90g3mmx7d8ikgsgnqlvza";
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
