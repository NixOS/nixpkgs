{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, cryptography
, pefile
}:

buildPythonPackage rec {
  pname = "virt-firmware";
  version = "23.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2b4c876e4b82951f89d349170e9e7dbe4ea7b277838c9e7376f802b9a75c6d3";
  };

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
