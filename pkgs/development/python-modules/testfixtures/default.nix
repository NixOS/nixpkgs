{ stdenv, buildPythonPackage, fetchPypi
, mock, manuel, pytest, sybil, zope_component, django }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d72c34cb6c21e73b673ee77d071d62c8342d1b444676575f46ddf39be0a62eb7";
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
