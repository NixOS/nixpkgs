{ stdenv, buildPythonPackage, fetchPypi
, mock, manuel, pytest, sybil, zope_component, django }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "338aed9695c432b7c9b8a271dabb521e3e7e2c96b11f7b4e60552f1c8408a8f0";
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
