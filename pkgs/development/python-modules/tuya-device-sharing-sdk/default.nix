{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  paho-mqtt,
  cryptography,
}:
let
  pname = "tuya-device-sharing-sdk";
  version = "0.1.9";
in
buildPythonPackage {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mBKR+ttBo0VF33pEmYdjbyM4bGgyDiYexIIsf8mXZW4=";
  };

  # workaround needed, upstream issue: https://github.com/tuya/tuya-device-sharing-sdk/issues/10
  postPatch = ''
    touch requirements.txt
  '';

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
