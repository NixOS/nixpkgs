{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  paho-mqtt,
  cryptography,
}:
let
  pname = "tuya-device-sharing-sdk";
  version = "0.2.5";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tuya";
    repo = "tuya-device-sharing-sdk";
    # no tags on GitHub: https://github.com/tuya/tuya-device-sharing-sdk/issues/2
    # no sdist on PyPI: https://github.com/tuya/tuya-device-sharing-sdk/issues/41
    rev = "b2156585daefa39fcd2feff964e9be53124697f1";
    hash = "sha256-ypAS8tzO4Wyc8pVjSiGaNNl+2fkFNcC3Ftql3l2B8k8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    paho-mqtt
    cryptography
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Tuya Device Sharing SDK";
    homepage = "https://github.com/tuya/tuya-device-sharing-sdk";
    license = licenses.mit;
    maintainers = with maintainers; [ aciceri ];
  };
}
