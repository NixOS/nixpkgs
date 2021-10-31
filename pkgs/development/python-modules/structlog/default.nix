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
  version = "21.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ac42b565e1295712313f91edbcb64e0840a9037d888c8954f11fa6c43270e99";
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
