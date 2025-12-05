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

  nativeCheckInputs = [
    flaky
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
  ++ optional-dependencies.watchmedo
  ++ lib.optionals (pythonOlder "3.13") [ eventlet ];

  disabledTestPaths = [
    "tests/test_emitter.py::test_create_wrong_encoding"
    "tests/test_emitter.py::test_close"
    # tests timeout easily
    "tests/test_inotify_buffer.py"
    # assert cap.out.splitlines(keepends=False).count('+++++ 0') == 2 != 3
    "tests/test_0_watchmedo.py::test_auto_restart_on_file_change_debounce"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/test_emitter.py::test_case_change"
    "tests/test_emitter.py::test_chmod"
    "tests/test_emitter.py::test_create"
    "tests/test_emitter.py::test_delete"
    "tests/test_emitter.py::test_fast_subdirectory_creation_deletion"
    "tests/test_emitter.py::test_file_lifecyle"
    "tests/test_emitter.py::test_modify"
    "tests/test_emitter.py::test_move_from"
    "tests/test_emitter.py::test_move_nested_subdirectories"
    "tests/test_emitter.py::test_move"
    "tests/test_emitter.py::test_recursive_off"
    "tests/test_emitter.py::test_recursive_on"
    "tests/test_emitter.py::test_renaming_top_level_directory"
    "tests/test_emitter.py::test_separate_consecutive_moves"
    "tests/test_fsevents.py::test_converting_cfstring_to_pyunicode"
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
