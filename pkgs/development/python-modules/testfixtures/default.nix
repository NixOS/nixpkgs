{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, isPy27
, mock, pytest, sybil, zope_component, twisted }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kiv60i0s67v34x28j6cshby7n7mbhd7a7val639yvvlh1f0q8wx";
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
