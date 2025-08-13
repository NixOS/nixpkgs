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
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # segfaults the testsuite
    "tests/test_emitter.py"
    # unsupported on x86_64-darwin
    "tests/test_fsevents.py"
    # fails to stop process in teardown
    "tests/test_0_watchmedo.py::test_auto_restart_subprocess_termination"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # FileCreationEvent != FileDeletionEvent
    "tests/test_emitter.py::test_separate_consecutive_moves"
    "tests/test_observers_polling.py::test___init__"
    # segfaults
    "tests/test_delayed_queue.py::test_delayed_get"
    "tests/test_emitter.py::test_delete"
    # AttributeError: '_thread.RLock' object has no attribute 'key'"
    "tests/test_skip_repeats_queue.py::test_eventlet_monkey_patching"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # segfaults
    "tests/test_delayed_queue.py::test_delayed_get"
    "tests/test_0_watchmedo.py::test_tricks_from_file"
    "tests/test_fsevents.py::test_watcher_deletion_while_receiving_events_1"
    "tests/test_fsevents.py::test_watcher_deletion_while_receiving_events_2"
    "tests/test_skip_repeats_queue.py::test_eventlet_monkey_patching"
    "tests/test_fsevents.py::test_recursive_check_accepts_relative_paths"
    # fsevents:fsevents.py:318 Unhandled exception in FSEventsEmitter
    "tests/test_fsevents.py::test_watchdog_recursive"
    # SystemError: Cannot start fsevents stream. Use a kqueue or polling observer...
    "tests/test_fsevents.py::test_add_watch_twice"
    # gets stuck
    "tests/test_fsevents.py::test_converting_cfstring_to_pyunicode"
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
