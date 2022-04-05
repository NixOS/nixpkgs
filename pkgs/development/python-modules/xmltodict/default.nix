{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xmltodict";
  version = "0.12.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21";
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Makes working with XML feel like you are working with JSON";
    homepage = "https://github.com/martinblech/xmltodict";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
