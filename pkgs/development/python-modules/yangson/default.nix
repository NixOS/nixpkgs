{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, elementpath
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jpu0tOquqlOb29Ln5T1WNKMHz6reYbvvcDVLUmJPe6A=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    elementpath
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
    maintainers = with maintainers; [ ];
  };
}
