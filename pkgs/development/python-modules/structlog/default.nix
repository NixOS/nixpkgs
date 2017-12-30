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
  version = "16.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00dywyg3bqlkrmbrfrql21hpjjjkc4zjd6xxjyxyd15brfnzlkdl";
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