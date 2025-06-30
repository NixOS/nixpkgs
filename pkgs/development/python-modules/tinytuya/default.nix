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
  version = "1.17.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jasonacox";
    repo = "tinytuya";
    tag = "v${version}";
    hash = "sha256-ivtd61r68kUP/OOIkdTjVI5FiD7QsYe6eSr2WiVF7OI=";
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
    changelog = "https://github.com/jasonacox/tinytuya/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ pathob ];
  };
}
