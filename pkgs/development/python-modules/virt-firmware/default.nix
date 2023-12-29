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
  version = "23.10";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-orTIduS4KVH4nTSRcOnn2+Tqeyd4OMnnN2+AK5p1xtM=";
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
