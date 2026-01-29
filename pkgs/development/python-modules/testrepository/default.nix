{
  lib,
  buildPythonPackage,
  fetchPypi,
  testtools,
  testresources,
  pbr,
  subunit,
  fixtures,
  python,
}:

buildPythonPackage rec {
  pname = "testrepository";
  version = "0.0.22";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P2OTyehG2QxWqDxD+2uAPKEexMbvvlPJTOW1xiqsNxM=";
  };

  nativeCheckInputs = [ testresources ];
  buildInputs = [ pbr ];
  propagatedBuildInputs = [
    fixtures
    subunit
    testtools
  ];

  checkPhase = ''
    ${python.interpreter} ./testr
  '';

  meta = {
    description = "Database of test results which can be used as part of developer workflow";
    mainProgram = "testr";
    homepage = "https://pypi.python.org/pypi/testrepository";
    license = lib.licenses.bsd2;
  };
}
