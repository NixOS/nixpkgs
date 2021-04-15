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
  version = "21.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9d2d890532e8db83c6977a2a676fb1889922ff0c26ad4dc0ecac26f9fafbc57";
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
