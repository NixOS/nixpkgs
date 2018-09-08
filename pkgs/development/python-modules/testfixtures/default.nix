{ stdenv, buildPythonPackage, fetchPypi
, mock, manuel, pytest, sybil, zope_component }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e4df89a8bf8b8905464160f08aff131a36f0b33654fe4f9e4387afe546eae25";
  };

  checkInputs = [ mock manuel pytest sybil zope_component ];

  checkPhase = ''
    # django is too much hasle to setup at the moment
    pytest --ignore=testfixtures/tests/test_django testfixtures/tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Simplistix/testfixtures;
  };
}
