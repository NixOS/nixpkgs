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
  version = "24.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bvk3MIgPY6DJ+y0eKQHLffClNjPAEP7AJ15rFObiMig=";
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
