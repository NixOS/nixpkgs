{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cryptography,
  requests,
  colorama,
}:

buildPythonPackage rec {
  pname = "tinytuya";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jasonacox";
    repo = "tinytuya";
    rev = "refs/tags/v${version}";
    hash = "sha256-ytM7S0V/hDOCb3RyzAXZEd2zV/sMVQPrah/2zRACMsQ=";
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
