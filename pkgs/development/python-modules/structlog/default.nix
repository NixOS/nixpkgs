{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pretend
, freezegun
, simplejson
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "17.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6980001045abd235fa12582222627c19b89109e58b85eb77d5a5abc778df6e20";
  };

  checkInputs = [ pytest pretend freezegun ];
  propagatedBuildInputs = [ simplejson ];

  checkPhase = ''
    rm tests/test_twisted.py*
    py.test
  '';

  meta = {
    description = "Painless structural logging";
    homepage = http://www.structlog.org/;
    license = lib.licenses.asl20;
  };
}