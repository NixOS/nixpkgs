{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, cython
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
  version = "0.17.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dd9rr5zxGhoixxSH858Vss9461vefltF+7meip2RueE=";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    libuv
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    ApplicationServices
  ];

  dontUseSetuptoolsCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
    psutil
  ] ++ lib.optionals (pythonOlder "3.11") [
    aiohttp
  ];

  LIBUV_CONFIGURE_HOST = stdenv.hostPlatform.config;

  pytestFlagsArray = [
    # from pytest.ini, these are NECESSARY to prevent failures
    "--capture=no"
    "--assert=plain"
    "--strict"
    "--tb=native"
    # Depend on pyopenssl
    "--deselect=tests/test_tcp.py::Test_UV_TCPSSL::test_flush_before_shutdown"
    "--deselect=tests/test_tcp.py::Test_UV_TCPSSL::test_renegotiation"
    # test gets stuck in epoll_pwait on hydras aarch64 builders
    # https://github.com/MagicStack/uvloop/issues/412
    "--deselect=tests/test_tcp.py::Test_AIO_TCPSSL::test_remote_shutdown_receives_trailing_data"
    # Tries to import cythonized file for which the .pyx file is not shipped via PyPi
    "--deselect=tests/test_libuv_api.py::Test_UV_libuv::test_libuv_get_loop_t_ptr"
    # Tries to run "env", but fails to find it
    "--deselect=tests/test_process.py::Test_UV_Process::test_process_env_2"
    "--deselect=tests/test_process.py::Test_AIO_Process::test_process_env_2"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Flaky test: https://github.com/MagicStack/uvloop/issues/412
    "--deselect=tests/test_tcp.py::Test_UV_TCPSSL::test_shutdown_timeout_handler_not_set"
    # Broken: https://github.com/NixOS/nixpkgs/issues/160904
    "--deselect=tests/test_context.py::Test_UV_Context::test_create_ssl_server_manual_connection_lost"
    # Flaky test: https://github.com/MagicStack/uvloop/issues/513
    "--deselect=tests/test_tcp.py::Test_UV_TCP::test_create_server_5"
    "--deselect=tests/test_tcp.py::Test_UV_TCP::test_create_server_6"
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
    # pyopenssl is not well supported by upstream
    # https://github.com/NixOS/nixpkgs/issues/175875
    substituteInPlace tests/test_tcp.py \
      --replace "from OpenSSL import SSL as openssl_ssl" ""
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
