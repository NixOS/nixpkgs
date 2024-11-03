{
  lib,
  stdenv,
  buildPythonPackage,
  eventlet,
  fetchPypi,
  flaky,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  apple-sdk_11,
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "6.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nd98gv2jro4k3s2hM47eZuHJmIPbk3Edj7lB6qLYwoI=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11;

  optional-dependencies.watchmedo = [ pyyaml ];

  nativeCheckInputs = [
    eventlet
    flaky
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ] ++ optional-dependencies.watchmedo;

  disabledTests =
    lib.optionals stdenv.hostPlatform.isDarwin [
      # fails to stop process in teardown
      "test_auto_restart_subprocess_termination"
      # assert cap.out.splitlines(keepends=False).count('+++++ 0') == 2 != 3
      "test_auto_restart_on_file_change_debounce"
      # segfaults
      "test_delayed_get"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # FileCreationEvent != FileDeletionEvent
      "test_separate_consecutive_moves"
      "test___init__"
      # segfaults
      "test_delete"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # segfaults
      "test_tricks_from_file"
    ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # segfaults the testsuite
    "tests/test_emitter.py"
    # unsupported on x86_64-darwin
    "tests/test_fsevents.py"
  ];

  pythonImportsCheck = [ "watchdog" ];

  meta = with lib; {
    description = "Python API and shell utilities to monitor file system events";
    mainProgram = "watchmedo";
    homepage = "https://github.com/gorakhargosh/watchdog";
    changelog = "https://github.com/gorakhargosh/watchdog/blob/v${version}/changelog.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
