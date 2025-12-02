{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  cython,
  setuptools,

  # native dependencies
  libuv,

  # tests
  psutil,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uvloop";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MagicStack";
    repo = "uvloop";
    tag = "v${version}";
    hash = "sha256-LAOa+Oshssy4ZHl4eE6dn2DeZQ9d5tRDV5Hv9BCJJ3c=";
  };

  postPatch = ''
    rm -rf vendor

    substituteInPlace setup.py \
      --replace-fail "use_system_libuv = False" "use_system_libuv = True"
  '';

  build-system = [
    cython
    setuptools
  ];

  env.LIBUV_CONFIGURE_HOST = stdenv.hostPlatform.config;

  buildInputs = [ libuv ];

  nativeCheckInputs = [
    pyopenssl
    pytestCheckHook
    psutil
  ];

  disabledTestPaths = [
    # ignore code linting tests
    "tests/test_sourcecode.py"
    # Tries to run "env", but fails to find it, even with coreutils provided
    "tests/test_process.py::Test_UV_Process::test_process_env_2"
    "tests/test_process.py::Test_AIO_Process::test_process_env_2"
    # AssertionError: b'' != b'out\n'
    "tests/test_process.py::Test_UV_Process::test_process_streams_redirect"
    "tests/test_process.py::Test_AIO_Process::test_process_streams_redirect"
    # Depends on performance of builder
    "tests/test_base.py::TestBaseUV.test_call_at"
    # Pointless and flaky (at least on darwin, depending on the sandbox perhaps)
    "tests/test_dns.py"
    # Asserts on exact wording of error message
    "tests/test_tcp.py::Test_AIO_TCP::test_create_connection_open_con_addr"
    # ConnectionAbortedError: SSL handshake is taking longer than 15.0 seconds
    "tests/test_tcp.py::Test_AIO_TCPSSL::test_create_connection_ssl_1"
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    "tests/test_tcp.py::Test_UV_TCPSSL::test_create_connection_ssl_failed_certificat"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # Segmentation fault
    "tests/test_fs_event.py::Test_UV_FS_EVENT_RENAME::test_fs_event_rename"
    # Broken: https://github.com/NixOS/nixpkgs/issues/160904
    "tests/test_context.py::Test_UV_Context::test_create_ssl_server_manual_connection_lost"
  ];

  preCheck = ''
    # force using installed/compiled uvloop
    rm -rf uvloop
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Work around "OSError: AF_UNIX path too long"
    # https://github.com/MagicStack/uvloop/issues/463
    export TMPDIR="/tmp"
  '';

  pythonImportsCheck = [
    "uvloop"
    "uvloop.loop"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/MagicStack/uvloop/releases/tag/v${version}";
    description = "Fast implementation of asyncio event loop on top of libuv";
    homepage = "https://github.com/MagicStack/uvloop";
    license = licenses.mit;
    maintainers = [ ];
  };
}
