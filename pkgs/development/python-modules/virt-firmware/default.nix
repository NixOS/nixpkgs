{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, cryptography
, pytestCheckHook
, pefile
}:

buildPythonPackage rec {
  pname = "virt-firmware";
  version = "24.1.1";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dUDfDQypP8hCo4eZcnUsOovgMksSX7hxMQI8mliCx2c=";
  };

  pythonImportsCheck = [ "virt.firmware.efi" ];

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = ["tests/tests.py"];

  propagatedBuildInputs = [
    setuptools
    cryptography
    pefile
  ];

  meta = with lib; {
    description = "Tools for virtual machine firmware volumes";
    homepage = "https://gitlab.com/kraxel/virt-firmware";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lheckemann raitobezarius ];
  };
}
