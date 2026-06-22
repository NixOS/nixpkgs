{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  py,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "simpy";
  version = "4.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-du82tx4ENrqU5V/rwAHHiHnkk6Mj8EW7z7sLIW6bH7w=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "simpy" ];

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests"
  ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.13") [
      # Failing on python >= 3.13
      # FAILED tests/test_exceptions.py::test_exception_chaining - AssertionError: Traceback mismatch
      "test_exception_chaining"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "test_rt"
      "test_rt_multiple_call"
      "test_rt_slow_sim_no_error"
    ];

  meta = {
    downloadPage = "https://github.com/simpx/simpy";
    homepage = "https://simpy.readthedocs.io/en/${version}/";
    description = "Process-based discrete-event simulation framework based on standard Python";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [
      shlevy
    ];
  };
}
