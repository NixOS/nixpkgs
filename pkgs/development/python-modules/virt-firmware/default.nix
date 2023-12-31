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
  version = "23.11";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9HA87J01M9VGCHdcmdlA50AikXG8vYHDw/5ig8h9YXc=";
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
