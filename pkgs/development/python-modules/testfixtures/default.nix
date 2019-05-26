{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, mock, pytest, sybil, zope_component }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x16xkw483nb1ngv74s7lgaj514pb1ldklal7kb7iwqbxcgnrh2k";
  };

  checkInputs = [ pytest mock sybil zope_component ];

  patches = [
    # Fix tests for Python 3.7. Remove with the next release
    (fetchpatch {
      url = https://github.com/Simplistix/testfixtures/commit/6e8807543b804946aba58e2c9e92f5bdc3656a57.patch;
      sha256 = "1584jz2qz04arx8z8f6d1l1vab7gi38k3akzm223rmp7j4m7yrii";
    })
  ];

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
