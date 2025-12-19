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
  version = "0.2.6";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tuya";
    repo = "tuya-device-sharing-sdk";
    # no tags on GitHub: https://github.com/tuya/tuya-device-sharing-sdk/issues/2
    # no sdist on PyPI: https://github.com/tuya/tuya-device-sharing-sdk/issues/41
    # check the dev branch for new changes
    rev = "86c0510e7229b9cf41b2bae57f3557a4d83c1928";
    hash = "sha256-nL7lr6HC+YpvmAdTnR6hzzn+9MEgzHkyzZuwjzsFHV0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    paho-mqtt
    cryptography
  ];

  doCheck = false; # no tests

  meta = {
    description = "Tuya Device Sharing SDK";
    homepage = "https://github.com/tuya/tuya-device-sharing-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
  };
}
