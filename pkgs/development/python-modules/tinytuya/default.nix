{
  lib,
  buildPythonPackage,
  colorama,
  cryptography,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tinytuya";
  version = "1.17.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jasonacox";
    repo = "tinytuya";
    tag = "v${version}";
    hash = "sha256-iX16Hqlvp0YIlhSFLa3MYAKOr+Z2ubPBPwI1883m5p4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    requests
    colorama
  ];

  # Tests require real network resources
  doCheck = false;

  pythonImportsCheck = [ "tinytuya" ];

  meta = {
    description = "Python API for Tuya WiFi smart devices using a direct local area network (LAN) connection or the cloud (TuyaCloud API)";
    homepage = "https://github.com/jasonacox/tinytuya";
    changelog = "https://github.com/jasonacox/tinytuya/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pathob ];
  };
}
