{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pyxb
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.4.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qb8zssyj504yrj1jnkrzv65xlfv5bl14knan76pjzbpl0xpaq6z";
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
