{
  lib,
  buildPythonPackage,
  colorama,
  cryptography,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tinytuya";
  version = "1.15.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jasonacox";
    repo = "tinytuya";
    rev = "refs/tags/v${version}";
    hash = "sha256-T7bT4be/h67iPIH/7hjNCYsUDP+4o4HLV523sBIjGVs=";
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

  meta = with lib; {
    description = "Python API for Tuya WiFi smart devices using a direct local area network (LAN) connection or the cloud (TuyaCloud API)";
    homepage = "https://github.com/jasonacox/tinytuya";
    changelog = "https://github.com/jasonacox/tinytuya/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pathob ];
  };
}
