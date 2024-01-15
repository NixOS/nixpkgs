{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, elementpath
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.4.19";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rYUxv3TEdyr2D3UEmmHcJJtlG6gXJnp1c2pez4H13SU=";
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
