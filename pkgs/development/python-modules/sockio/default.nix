{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sockio";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiagocoutinho";
    repo = "sockio";
    tag = "v${version}";
    hash = "sha256-NSGd7/k1Yr408dipMNBSPRSwQ+wId7VLxgqMM/UmN/Q=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--durations=2 --verbose" ""
  '';

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sockio" ];

  disabledTests = [
    # Tests require network access
    "test_open_timeout"
    "test_write_readline_error"
    "test_open_close"
    "test_callbacks"
    "test_coroutine_callbacks"
    "test_error_callback"
    "test_eof_callback"
    "test_write_read"
    "test_write_readline"
    "test_write_readlines"
    "test_writelines_readlines"
    "test_writelines"
    "test_readline"
    "test_readuntil"
    "test_readexactly"
    "test_readlines"
    "test_read"
    "test_readbuffer"
    "test_parallel_rw"
    "test_parallel"
    "test_stream"
    "test_timeout"
    "test_line_stream"
    "test_block_stream"
    "test_socket_for_url"
    "test_root_socket_for_url"
  ];

  disabledTestPaths = [
    # We don't care about Python 2.x
    "tests/test_py2.py"
  ];

  meta = with lib; {
    description = "Implementation of the Modbus protocol";
    homepage = "https://tiagocoutinho.github.io/sockio/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
