{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-asyncio
, python-rapidjson
, pretend
, freezegun
, twisted
, simplejson
, six
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "21.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "305a66201f9605a2e8a2595271a446f258175901c09c01e4c2c2a8ac5b68edf1";
  };

  checkInputs = [ pytest pytest-asyncio pretend freezegun simplejson twisted ]
    ++ lib.optionals (pythonAtLeast "3.6") [ python-rapidjson ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    # rm tests/test_twisted.py*
    py.test
  '';

  meta = {
    description = "Painless structural logging";
    homepage = "http://www.structlog.org/";
    license = lib.licenses.asl20;
  };
}
