{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pyxb
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.4.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Dx7jxhO3aGCT1Mq6QDsvZLDcC7EY3dX2ltM0tLxSW8Y=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyxb
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "yangson"
  ];

  meta = with lib; {
    description = "Library for working with data modelled in YANG";
    homepage = "https://github.com/CZ-NIC/yangson";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = with maintainers; [ hexa ];
  };
}
