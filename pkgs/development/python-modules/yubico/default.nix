{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pyusb,
}:

buildPythonPackage rec {
  pname = "python-yubico";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2EZkJ6pZIqxdS36cZbaTEIQnz1N9ZT1oyyEsBxPo5vU=";
  };

  propagatedBuildInputs = [ pyusb ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "yubico" ];

  disabledTests = [
    "usb" # requires a physical yubikey to test
  ];

  meta = with lib; {
    description = "Python code to talk to YubiKeys";
    homepage = "https://github.com/Yubico/python-yubico";
    license = licenses.bsd2;
    maintainers = with maintainers; [ s1341 ];
  };
}
