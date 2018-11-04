{ stdenv, buildPythonPackage, fetchPypi
, mock, manuel, pytest, sybil, zope_component }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53c06c1feb0bf378d63c54d1d96858978422d5a34793b39f0dcb0e44f8ec26f4";
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
