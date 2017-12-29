{ stdenv, buildPythonPackage, fetchPypi
, mock, manuel, pytest, sybil, zope_component, django }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xfar653qmikwb94xj3f0xfp8dh2llxjsxipx1272d8qwl0aknnx";
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
