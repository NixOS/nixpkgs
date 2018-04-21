{ stdenv, buildPythonPackage, fetchPypi
, mock, manuel, pytest, sybil, zope_component, django }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6c4cf24d043f9d8e9a9337371ec1d2f6638a0032504bd67dbd724224fd64969";
  };

  checkInputs = [ mock manuel pytest sybil zope_component ];

  checkPhase = ''
    # django is too much hasle to setup at the moment
    pytest --ignore=testfixtures/tests/test_django testfixtures/tests
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Simplistix/testfixtures";
  };
}
