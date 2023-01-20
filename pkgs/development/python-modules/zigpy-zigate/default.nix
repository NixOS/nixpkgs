{ lib
, buildPythonPackage
, fetchFromGitHub
, gpiozero
, mock
, pyserial
, pyserial-asyncio
, pyusb
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-zigate";
  version = "0.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-zigate";
    rev = "refs/tags/v${version}";
    hash = "sha256-g6EFc9z9LrUawDczgGaIt5o+Vgp5U3swJJD8VftL4bQ=";
  };

  propagatedBuildInputs = [
    gpiozero
    pyserial
    pyserial-asyncio
    pyusb
    zigpy
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zigpy_zigate"
  ];

  disabledTestPaths = [
    # Fails in sandbox
    "tests/test_application.py "
  ];

  meta = with lib; {
    description = "Library which communicates with ZiGate radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-zigate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
