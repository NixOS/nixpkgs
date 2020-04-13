{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, flit
, pytest
, pytestcov
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "threadpoolctl";
  version = "2.0.0";

  disabled = isPy27;
  format = "flit";

  src = fetchFromGitHub {
    owner = "joblib";
    repo = pname;
    rev = version;
    sha256 = "16z4n82f004i4l1jw6qrzazda1m6v2yjnpqlp71ipa8mzy9kw7dw";
  };

  checkInputs = [ pytest pytestcov numpy scipy ];

  checkPhase = "pytest tests -k 'not test_nested_prange_blas'";
  # cython doesn't get run on the tests when added to nativeBuildInputs, breaking this test

  meta = with lib; {
    homepage = "https://github.com/joblib/threadpoolctl";
    description = "Helpers to limit number of threads used in native libraries";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };

}
