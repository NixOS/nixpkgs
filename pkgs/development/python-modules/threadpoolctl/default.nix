{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, flit
, pytestCheckHook
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "threadpoolctl";
  version = "2.2.0";

  disabled = isPy27;
  format = "flit";

  src = fetchFromGitHub {
    owner = "joblib";
    repo = pname;
    rev = version;
    sha256 = "7UUjbX1IpXtUAgN48Db43Zr1u360UETSUnIHD6rQRLs=";
  };

  checkInputs = [ pytestCheckHook numpy scipy ];
  disabledTests = [
    # accepts a limited set of cpu models based on project
    # developers' hardware
    "test_architecture"
  ];

  meta = with lib; {
    homepage = "https://github.com/joblib/threadpoolctl";
    description = "Helpers to limit number of threads used in native libraries";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };

}
