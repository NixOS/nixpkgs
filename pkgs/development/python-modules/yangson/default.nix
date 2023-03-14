{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pyxb
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.4.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yw/LwWjHW4vgHp06E/DgqauTvdfLxerHw1avge91XLU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyxb
  ];

  nativeCheckInputs = [
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
