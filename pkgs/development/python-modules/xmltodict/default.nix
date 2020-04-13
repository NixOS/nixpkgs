{ lib
, buildPythonPackage
, fetchPypi
, coverage
, nose
}:

buildPythonPackage rec {
  pname = "xmltodict";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21";
  };

  checkInputs = [ coverage nose ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    description = "Makes working with XML feel like you are working with JSON";
    homepage = "https://github.com/martinblech/xmltodict";
    license = lib.licenses.mit;
  };
}
