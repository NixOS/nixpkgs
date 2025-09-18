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
  version = "0.2.4";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4RwsuFg2ukvM0rplCZKJx85DbJTpJnhkCVDnfT4r4A8=";
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
