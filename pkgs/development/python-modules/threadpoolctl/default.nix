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
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "joblib";
    repo = pname;
    rev = version;
    hash = "sha256-/qt7cgFbvpc1BLZC7a4S0RToqSggKXAqF1Xr6xOqzw8=";
  };

  checkInputs = [
    numpy
    pytestCheckHook
    scipy
  ];

  disabledTests = [
    # accepts a limited set of CPU models based on project
    # developers' hardware
    "test_architecture"
    # https://github.com/joblib/threadpoolctl/issues/128
    "test_threadpool_limits_by_prefix"
    "test_controller_info_actualized"
    "test_command_line_command_flag"
    "test_command_line_import_flag"
    # Fails on Hydra
    "test_set_threadpool_limits_by_api"
  ];

  pythonImportsCheck = [
    "threadpoolctl"
  ];

  meta = with lib; {
    description = "Helpers to limit number of threads used in native libraries";
    homepage = "https://github.com/joblib/threadpoolctl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };

}
