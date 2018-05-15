{ stdenv, buildPythonPackage, fetchPypi
, mock, manuel, pytest, sybil, zope_component, django }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8827cfc91e5cc9ac669727fdd48a85880f391b935a0a212b5cedb807879feec";
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
