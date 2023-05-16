{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ospd-openvas";
<<<<<<< HEAD
  version = "22.6.0";
=======
  version = "22.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "ospd-openvas";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-1538XMNnerhfV3xQ8/TyoztCfWnkRvy0p6QtKMQb2p4=";
=======
    hash = "sha256-1dzpS5Hov+48BYOkPicVk1duaNM5ueXNr7UKg6aPoZA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonRelaxDeps = [
    "packaging"
    "python-gnupg"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    deprecated
    lxml
    packaging
    paho-mqtt
    psutil
    python-gnupg
    redis
    sentry-sdk
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ospd_openvas"
  ];

  meta = with lib; {
    description = "OSP server implementation to allow GVM to remotely control an OpenVAS Scanner";
    homepage = "https://github.com/greenbone/ospd-openvas";
<<<<<<< HEAD
    changelog = "https://github.com/greenbone/ospd-openvas/releases/tag/v${version}";
=======
    changelog = "https://github.com/greenbone/ospd-openvas/blob/${version}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
