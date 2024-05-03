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
  version = "24.4";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rqhaKDOQEOj6bcRz3qZJ+a4yG1qTC9SUjuxMhZlnmwU=";
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
