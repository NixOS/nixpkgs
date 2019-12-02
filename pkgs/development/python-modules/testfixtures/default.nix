{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, isPy27
, mock, pytest, sybil, zope_component, twisted }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0eb9d20ce3b53e0cf543da7c46c263cc9792f13223def8b26edb6180ecdc895";
  };

  checkInputs = [ pytest mock sybil zope_component twisted ];

  doCheck = !isPy27;
  checkPhase = ''
    # django is too much hasle to setup at the moment
    pytest -W ignore::DeprecationWarning --ignore=testfixtures/tests/test_django testfixtures/tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Simplistix/testfixtures;
    description = "A collection of helpers and mock objects for unit tests and doc tests";
    license = licenses.mit;
  };
}
