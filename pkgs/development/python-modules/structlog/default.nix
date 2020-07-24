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
  version = "20.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a48375db6274ed1d0ae6123c486472aa1d0890b08d314d2b016f3aa7f35990b";
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
