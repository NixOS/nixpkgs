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
  version = "19.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dgs6g5wgmqfr4ydygkgmp8jiz49hpm1b29ymv9j8232cwqy1sjz";
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
