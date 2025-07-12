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
  setuptools,
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "6.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nd98gv2jro4k3s2hM47eZuHJmIPbk3Edj7lB6qLYwoI=";
  };

  build-system = [ setuptools ];

  optional-dependencies.watchmedo = [ pyyaml ];

  nativeCheckInputs =
    [
      flaky
      pytest-cov-stub
      pytest-timeout
      pytestCheckHook
    ]
    ++ optional-dependencies.watchmedo
    ++ lib.optionals (pythonOlder "3.13") [ eventlet ];

  pytestFlagsArray = [
    "--deselect=tests/test_emitter.py::test_create_wrong_encoding"
    "--deselect=tests/test_emitter.py::test_close"
    # assert cap.out.splitlines(keepends=False).count('+++++ 0') == 2 != 3
    "--deselect=tests/test_0_watchmedo.py::test_auto_restart_on_file_change_debounce"
  ];

  disabledTestPaths =
    [
      # tests timeout easily
      "tests/test_inotify_buffer.py"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # segfaults the testsuite
      "tests/test_emitter.py"
      # unsupported on x86_64-darwin
      "tests/test_fsevents.py"
    ];

  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.FSEvents"))
  '';

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
