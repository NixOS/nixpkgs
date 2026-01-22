{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pyusb,
}:

buildPythonPackage rec {
  pname = "python-yubico";
  version = "1.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2EZkJ6pZIqxdS36cZbaTEIQnz1N9ZT1oyyEsBxPo5vU=";
  };

  propagatedBuildInputs = [ pyusb ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "yubico" ];

  disabledTests = [
    "usb" # requires a physical yubikey to test
  ];

  meta = {
    description = "Python code to talk to YubiKeys";
    homepage = "https://github.com/Yubico/python-yubico";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ s1341 ];
  };
}
