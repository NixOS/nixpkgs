{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.21.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-YRJMIpC6Zk5sQjGyzdEbQEeYgFJzIbxe4BReayceu10=";
  };

  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zigpy_deconz"
  ];

  meta = with lib; {
    description = "Library which communicates with Deconz radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-deconz";
    changelog = "https://github.com/zigpy/zigpy-deconz/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
