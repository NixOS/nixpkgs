{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "15.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = "websockets";
    tag = version;
    hash = "sha256-DC1nK+TvCoCqchyWJOyT4Ul4gkTYXixu7XmTqvytqEo=";
  };

  build-system = [ setuptools ];

  disabledTests = [
    # Disables tests relying on tight timeouts to avoid failures like:
    #   File "/build/source/tests/legacy/test_protocol.py", line 1270, in test_keepalive_ping_with_no_ping_timeout
    #     ping_1_again, ping_2 = tuple(self.protocol.pings)
    #   ValueError: too many values to unpack (expected 2)
    "test_keepalive_ping_stops_when_connection_closing"
    "test_keepalive_ping_does_not_crash_when_connection_lost"
    "test_keepalive_ping"
    "test_keepalive_ping_not_acknowledged_closes_connection"
    "test_keepalive_ping_with_no_ping_timeout"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/python-websockets/websockets/issues/1569
    "test_writing_in_send_context_fails"
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    # Our Python 3.10 and older raise SSLError instead of SSLCertVerificationError
    "test_reject_invalid_server_certificate"
  ];

  nativeCheckInputs = [
    unittestCheckHook
    werkzeug
  ];

  preCheck = ''
    # https://github.com/python-websockets/websockets/issues/1509
    export WEBSOCKETS_TESTS_TIMEOUT_FACTOR=100
    # Disable all tests that need to terminate within a predetermined amount of
    # time. This is nondeterministic.
    sed -i 's/with self.assertCompletesWithin.*:/if True:/' \
      tests/legacy/test_protocol.py
  '';

  # Tests fail on Darwin with `OSError: AF_UNIX path too long`
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "websockets" ];

  meta = with lib; {
    description = "WebSocket implementation in Python";
    homepage = "https://websockets.readthedocs.io/";
    changelog = "https://github.com/aaugustin/websockets/blob/${src.tag}/docs/project/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
