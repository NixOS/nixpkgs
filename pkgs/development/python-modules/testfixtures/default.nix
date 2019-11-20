{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, isPy27
, mock, pytest, sybil, zope_component, twisted }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abbca7ed381d34a77699c6cb68be67919a1e7f5cf8728b57396145417fa34110";
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
