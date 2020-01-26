{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, isPy27
, mock, pytest, sybil, zope_component, twisted }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f22100d4fb841b958f64e71c8820a32dc46f57d4d7e077777b932acd87b7327";
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
