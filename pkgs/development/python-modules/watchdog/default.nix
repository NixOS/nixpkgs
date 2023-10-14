{ lib
, stdenv
, buildPythonPackage
, CoreServices
, eventlet
, fetchpatch
, fetchPypi
, flaky
, pytest-timeout
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TZijIFldp6fFoY/EjLYzwuc82nj5PKwu9C1Cv2CaM/k=";
  };

  # force kqueue on x86_64-darwin, because our api version does
  # not support fsevents
  patches = lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
    ./force-kqueue.patch
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  passthru.optional-dependencies.watchmedo = [
    pyyaml
  ];

  nativeCheckInputs = [
    eventlet
    flaky
    pytest-timeout
    pytestCheckHook
  ] ++ passthru.optional-dependencies.watchmedo;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=watchdog" "" \
      --replace "--cov-report=term-missing" ""
  '';

  pytestFlagsArray = [
    "--deselect=tests/test_emitter.py::test_create_wrong_encoding"
    "--deselect=tests/test_emitter.py::test_close"
  ] ++ lib.optionals (stdenv.isDarwin) [
    # fails to stop process in teardown
    "--deselect=tests/test_0_watchmedo.py::test_auto_restart_subprocess_termination"
    # assert cap.out.splitlines(keepends=False).count('+++++ 0') == 2 != 3
    "--deselect=tests/test_0_watchmedo.py::test_auto_restart_on_file_change_debounce"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # FileCreationEvent != FileDeletionEvent
    "--deselect=tests/test_emitter.py::test_separate_consecutive_moves"
    "--deselect=tests/test_observers_polling.py::test___init__"
    # segfaults
    "--deselect=tests/test_delayed_queue.py::test_delayed_get"
    "--deselect=tests/test_emitter.py::test_delete"
    # AttributeError: '_thread.RLock' object has no attribute 'key'"
    "--deselect=tests/test_skip_repeats_queue.py::test_eventlet_monkey_patching"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # segfaults
    "--deselect=tests/test_delayed_queue.py::test_delayed_get"
    "--deselect=tests/test_0_watchmedo.py::test_tricks_from_file"
    "--deselect=tests/test_fsevents.py::test_watcher_deletion_while_receiving_events_1"
    "--deselect=tests/test_fsevents.py::test_watcher_deletion_while_receiving_events_2"
    "--deselect=tests/test_skip_repeats_queue.py::test_eventlet_monkey_patching"
    "--deselect=tests/test_fsevents.py::test_recursive_check_accepts_relative_paths"
    # fsevents:fsevents.py:318 Unhandled exception in FSEventsEmitter
    "--deselect=tests/test_fsevents.py::test_watchdog_recursive"
    # SystemError: Cannot start fsevents stream. Use a kqueue or polling observer...
    "--deselect=tests/test_fsevents.py::test_add_watch_twice"
    # fsevents:fsevents.py:318 Unhandled exception in FSEventsEmitter
    "--deselect=ests/test_fsevents.py::test_recursive_check_accepts_relative_paths"
    # gets stuck
    "--deselect=tests/test_fsevents.py::test_converting_cfstring_to_pyunicode"
  ];

  disabledTestPaths = [
    # tests timeout easily
    "tests/test_inotify_buffer.py"
  ] ++ lib.optionals (stdenv.isDarwin) [
    # segfaults the testsuite
    "tests/test_emitter.py"
    # unsupported on x86_64-darwin
    "tests/test_fsevents.py"
  ];

  pythonImportsCheck = [
    "watchdog"
  ];

  meta = with lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = "https://github.com/gorakhargosh/watchdog";
    changelog = "https://github.com/gorakhargosh/watchdog/blob/v${version}/changelog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
