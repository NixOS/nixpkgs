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
  version = "19.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4287058cf4ce1a59bc5dea290d6386d37f29a37529c9a51cdf7387e51710152b";
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
