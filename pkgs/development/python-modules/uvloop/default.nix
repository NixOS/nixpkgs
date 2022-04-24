{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, libuv
, CoreServices
, ApplicationServices
# Check Inputs
, aiohttp
, psutil
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "uvloop";
  version = "0.16.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f74bc20c7b67d1c27c72601c78cf95be99d5c2cdd4514502b4f3eb0933ff1228";
  };

  buildInputs = [
    libuv
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    ApplicationServices
  ];

  dontUseSetuptoolsCheck = true;
  checkInputs = [
    aiohttp
    pytestCheckHook
    pyopenssl
    psutil
  ];

  LIBUV_CONFIGURE_HOST = stdenv.hostPlatform.config;

  pytestFlagsArray = [
    # from pytest.ini, these are NECESSARY to prevent failures
    "--capture=no"
    "--assert=plain"
    "--strict"
    "--tb=native"
  ] ++ lib.optionals (stdenv.isAarch64) [
    # test gets stuck in epoll_pwait on hydras aarch64 builders
    # https://github.com/MagicStack/uvloop/issues/412
    "--deselect" "tests/test_tcp.py::Test_AIO_TCPSSL::test_remote_shutdown_receives_trailing_data"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Flaky test: https://github.com/MagicStack/uvloop/issues/412
    "--deselect" "tests/test_tcp.py::Test_UV_TCPSSL::test_shutdown_timeout_handler_not_set"
    # Broken: https://github.com/NixOS/nixpkgs/issues/160904
    "--deselect" "tests/test_context.py::Test_UV_Context::test_create_ssl_server_manual_connection_lost"
  ];

  disabledTestPaths = [
    # ignore code linting tests
    "tests/test_sourcecode.py"
  ];

  preCheck = lib.optionalString stdenv.isDarwin ''
    # Work around "OSError: AF_UNIX path too long"
    # https://github.com/MagicStack/uvloop/issues/463
    export TMPDIR="/tmp"
   '' + ''
    # force using installed/compiled uvloop vs source by moving tests to temp dir
    export TEST_DIR=$(mktemp -d)
    cp -r tests $TEST_DIR
    pushd $TEST_DIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "uvloop"
    "uvloop.loop"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Fast implementation of asyncio event loop on top of libuv";
    homepage = "https://github.com/MagicStack/uvloop";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
