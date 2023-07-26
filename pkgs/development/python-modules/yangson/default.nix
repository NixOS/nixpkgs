{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, elementpath
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.4.18";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VMgx2MTiOoAw8tW8SckheN950JVbdWWSS3PWDNs0dT0=";
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
    maintainers = with maintainers; [ hexa ];
  };
}
