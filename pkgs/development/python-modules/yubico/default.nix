{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pyusb,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-yubico";
  version = "1.3.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2EZkJ6pZIqxdS36cZbaTEIQnz1N9ZT1oyyEsBxPo5vU=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyusb ];

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
})
