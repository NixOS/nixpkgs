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
    sha256 = "0f1ee3c613b7686093d4caba403b2f64b0dc0bb118ddd5f696d334b4bc525bc6";
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
