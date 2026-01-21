{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  paho-mqtt,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "tuya-device-sharing-sdk";
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tuya";
    repo = "tuya-device-sharing-sdk";
    tag = finalAttrs.version;
    hash = "sha256-kNWg+AXISThwK14ByObUr+/4GMntrZgtEEMNpw/HjLw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    paho-mqtt
    requests
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "tuya_sharing" ];

  meta = {
    description = "Tuya Device Sharing SDK";
    homepage = "https://github.com/tuya/tuya-device-sharing-sdk";
    changelog = "https://github.com/tuya/tuya-device-sharing-sdk/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
  };
})
