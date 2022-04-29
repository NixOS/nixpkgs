{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = pname;
    rev = version;
    sha256 = "sha256-FFaoqxa+TmKJ+P6T7HrwodjbVCir+2qJSfZsoj6deJU=";
  };

  # Tests fail on Darwin with `OSError: AF_UNIX path too long`
  doCheck = !stdenv.isDarwin;

  patchPhase = ''
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
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [
    "websockets"
  ];

  meta = with lib; {
    description = "WebSocket implementation in Python";
    homepage = "https://websockets.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
