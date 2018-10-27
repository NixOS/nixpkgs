{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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
  version = "18.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e361edb3b9aeaa85cd38a1bc9ddbb60cda8a991fc29de9db26832f6300e81eb4";
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
