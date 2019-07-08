{ lib
, buildPythonPackage
, fetchPypi
, pytest
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
  version = "19.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5feae03167620824d3ae3e8915ea8589fc28d1ad6f3edf3cc90ed7c7cb33fab5";
  };

  checkInputs = [ pytest pretend freezegun simplejson twisted ]
    ++ lib.optionals (pythonAtLeast "3.6") [ python-rapidjson ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    # rm tests/test_twisted.py*
    py.test
  '';

  meta = {
    description = "Painless structural logging";
    homepage = http://www.structlog.org/;
    license = lib.licenses.asl20;
  };
}
