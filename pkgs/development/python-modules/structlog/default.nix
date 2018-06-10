{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytest
, pretend
, freezegun
, simplejson
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "17.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6980001045abd235fa12582222627c19b89109e58b85eb77d5a5abc778df6e20";
  };

  patches = [
    # Fix tests for pytest 3.3
    (fetchpatch {
      url = "https://github.com/hynek/structlog/commit/22f0ae50607a0cb024361599f84610ce290deb99.patch";
      sha256 = "03622i13ammkpyrdk48kimbz94gbkpcmdpy0kj2z09m1kp6q2ljv";
    })
  ];

  checkInputs = [ pytest pretend freezegun ];
  propagatedBuildInputs = [ simplejson ];

  checkPhase = ''
    rm tests/test_twisted.py*
    py.test
  '';

  meta = {
    description = "Painless structural logging";
    homepage = http://www.structlog.org/;
    license = lib.licenses.asl20;
  };
}
