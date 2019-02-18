{ stdenv
, buildPythonPackage
, fetchPypi
, testtools
, testresources
, pbr
, subunit
, fixtures
, python
}:

buildPythonPackage rec {
  pname = "testrepository";
  version = "0.0.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ssqb07c277010i6gzzkbdd46gd9mrj0bi0i8vn560n2k2y4j93m";
  };

  checkInputs = [ testresources ];
  buildInputs = [ pbr ];
  propagatedBuildInputs = [ fixtures subunit testtools ];

  checkPhase = ''
    ${python.interpreter} ./testr
  '';

  meta = with stdenv.lib; {
    description = "A database of test results which can be used as part of developer workflow";
    homepage = https://pypi.python.org/pypi/testrepository;
    license = licenses.bsd2;
  };

}
