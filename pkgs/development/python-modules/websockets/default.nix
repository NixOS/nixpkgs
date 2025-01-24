{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "13.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = "websockets";
    rev = "refs/tags/${version}";
    hash = "sha256-Y0HDZw+H7l8+ywLLzFk66GNDCI0uWOZYypG86ozLo7c=";
  };

  build-system = [ setuptools ];

  patchPhase =
    ''
      # Disable all tests that need to terminate within a predetermined amount of
      # time. This is nondeterministic.
      sed -i 's/with self.assertCompletesWithin.*:/if True:/' \
        tests/legacy/test_protocol.py

      # Disables tests relying on tight timeouts to avoid failures like:
      #   File "/build/source/tests/legacy/test_protocol.py", line 1270, in test_keepalive_ping_with_no_ping_timeout
      #     ping_1_again, ping_2 = tuple(self.protocol.pings)
      #   ValueError: too many values to unpack (expected 2)
      for t in \
               test_keepalive_ping_stops_when_connection_closing \
               test_keepalive_ping_does_not_crash_when_connection_lost \
               test_keepalive_ping \
               test_keepalive_ping_not_acknowledged_closes_connection \
               test_keepalive_ping_with_no_ping_timeout \
        ; do
        sed -i "s/def $t(/def skip_$t(/" tests/legacy/test_protocol.py
      done
    ''
    + lib.optionalString (pythonOlder "3.11") ''
      # Our Python 3.10 and older raise SSLError instead of SSLCertVerificationError
      sed -i "s/def test_reject_invalid_server_certificate(/def skip_test_reject_invalid_server_certificate(/" tests/sync/test_client.py
      sed -i "s/def test_reject_invalid_server_certificate(/def skip_test_reject_invalid_server_certificate(/" tests/asyncio/test_client.py
    '';

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    # https://github.com/python-websockets/websockets/issues/1509
    export WEBSOCKETS_TESTS_TIMEOUT_FACTOR=100
  '';

  # Tests fail on Darwin with `OSError: AF_UNIX path too long`
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "websockets" ];

  meta = with lib; {
    description = "WebSocket implementation in Python";
    homepage = "https://websockets.readthedocs.io/";
    changelog = "https://github.com/aaugustin/websockets/blob/${version}/docs/project/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
