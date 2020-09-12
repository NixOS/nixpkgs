{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, flit
, pytestCheckHook
, pytestcov
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "threadpoolctl";
  version = "2.1.0";

  disabled = isPy27;
  format = "flit";

  src = fetchFromGitHub {
    owner = "joblib";
    repo = pname;
    rev = version;
    sha256 = "0sl6mp3b2gb0dvqkhnkmrp2g3r5c7clyyyxzq44xih6sw1pgx9df";
  };

  checkInputs = [ pytestCheckHook pytestcov numpy scipy ];

  meta = with lib; {
    homepage = "https://github.com/joblib/threadpoolctl";
    description = "Helpers to limit number of threads used in native libraries";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };

}
