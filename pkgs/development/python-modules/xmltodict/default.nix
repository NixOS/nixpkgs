{ lib
, buildPythonPackage
, fetchPypi
, coverage
, nose
}:

buildPythonPackage rec {
  pname = "xmltodict";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f8d7d40aa28d83f4109a7e8aa86e67a4df202d9538be40c0cb1d70da527b0df";
  };

  checkInputs = [ coverage nose ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    description = "Makes working with XML feel like you are working with JSON";
    homepage = https://github.com/martinblech/xmltodict;
    license = lib.licenses.mit;
  };
}