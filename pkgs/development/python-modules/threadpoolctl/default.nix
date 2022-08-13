{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flit
, pytestCheckHook
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "threadpoolctl";
  version = "3.1.0";

  disabled = pythonOlder "3.6";
  format = "flit";

  src = fetchFromGitHub {
    owner = "joblib";
    repo = pname;
    rev = version;
    sha256 = "sha256-/qt7cgFbvpc1BLZC7a4S0RToqSggKXAqF1Xr6xOqzw8=";
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
