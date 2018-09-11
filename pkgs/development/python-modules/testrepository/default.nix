{ stdenv
, buildPythonPackage
, fetchPypi
, python
, testtools
, testresources
, testscenarios
, pbr
, subunit
, fixtures
, pytz
}:

buildPythonPackage rec {
  pname = "testrepository";
  version = "0.0.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "752449bc98c20253ec4611c40564aea93d435a5bf3ff672208e01cc10e5858eb";
  };

  checkInputs = [ pytz testscenarios testtools testresources ];
  propagatedBuildInputs = [ pbr subunit fixtures ];

  checkPhase = ''
    ${python.interpreter} ./testr init
    ${python.interpreter} ./testr run --parallel
  '';

  # skip tests becuase assumes weird directories to be created
  # previous did not even run the tests
  # 3 fail / 344 tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A database of test results which can be used as part of developer workflow";
    homepage = https://pypi.python.org/pypi/testrepository;
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
