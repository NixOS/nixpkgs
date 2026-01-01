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
  version = "0.0.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nor89+CQs8aIvddUol9kvDFOUSuBb4xxufn8F9w3o9k=";
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

<<<<<<< HEAD
  meta = {
    description = "Database of test results which can be used as part of developer workflow";
    mainProgram = "testr";
    homepage = "https://pypi.python.org/pypi/testrepository";
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    description = "Database of test results which can be used as part of developer workflow";
    mainProgram = "testr";
    homepage = "https://pypi.python.org/pypi/testrepository";
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
