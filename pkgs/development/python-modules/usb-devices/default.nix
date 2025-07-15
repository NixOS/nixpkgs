{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "usb-devices";
  version = "0.4.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "usb-devices";
    tag = "v${version}";
    hash = "sha256-Nfdl5oRIdOfAo5PFAJJpadRyu2zeEkmYzxDQxbvpt6c=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "usb_devices" ];

  meta = with lib; {
    description = "Library for for mapping, describing, and resetting USB devices";
    homepage = "https://github.com/Bluetooth-Devices/usb-devices";
    changelog = "https://github.com/Bluetooth-Devices/usb-devices/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
