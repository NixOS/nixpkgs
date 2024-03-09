{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, colorama
, requests
, cryptography
}:

buildPythonPackage rec {
  pname = "tinytuya";
  version = "1.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jasonacox";
    repo = "tinytuya";
    rev = "v${version}";
    hash = "sha256-3epv2z7WY1VhRLrCjxHkXjcCweJbWIWNRRwMG1xlWaA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    colorama
    requests
    cryptography
  ];

  pythonImportsCheck = [ "tinytuya" ];

  meta = with lib; {
    description = "Python API for Tuya WiFi smart devices using a direct local area network (LAN) connection or the cloud (TuyaCloud API";
    homepage = "https://github.com/jasonacox/tinytuya/";
    license = licenses.mit;
    maintainers = with maintainers; [ traxys ];
  };
}
