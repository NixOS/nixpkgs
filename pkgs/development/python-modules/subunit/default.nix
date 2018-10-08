{ stdenv
, pkgs
, buildPythonPackage
, fetchPypi
, python
, testtools
, testscenarios
, hypothesis
, fixtures
}:

buildPythonPackage rec {
  pname = "python-subunit";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9607edbee4c1e5a30ff88549ce8d9feb0b9bcbcb5e55033a9d76e86075465cbb";
  };

  checkInputs = [ testscenarios hypothesis fixtures ];
  propagatedBuildInputs = [ testtools ];

  checkPhase = ''
    ${python.interpreter} -m testtools.run subunit.tests.test_suite
  '';

  # requires full repository for tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://launchpad.net/subunit;
    description = "Python implementation of subunit test streaming protocol";
    license = licenses.asl20;
  };
}
