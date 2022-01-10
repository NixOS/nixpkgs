{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonAtLeast
, attrs
, sortedcontainers
, async_generator
, idna
, outcome
, contextvars
, pytestCheckHook
, pyopenssl
, trustme
, sniffio
, stdenv
, jedi
, astor
, yapf
}:

buildPythonPackage rec {
  pname = "trio";
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "895e318e5ec5e8cea9f60b473b6edb95b215e82d99556a03eb2d20c5e027efe1";
  };

  propagatedBuildInputs = [
    async_generator
    attrs
    idna
    outcome
    sniffio
    sortedcontainers
  ] ++ lib.optionals (pythonOlder "3.7") [
    contextvars
  ];

  checkInputs = [
    astor
    jedi
    pyopenssl
    pytestCheckHook
    trustme
    yapf
  ];

  disabledTests = [
    # It appears that the build sandbox doesn't include /etc/services, and these tests try to use it
    "getnameinfo"
    "SocketType_resolve"
    "getprotobyname"
    "waitpid"
    "static_tool_sees_all_symbols"
    # Tests pytest more than Python
    "fallback_when_no_hook_claims_it"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    "test_selected_npn_protocol_when_not_set"
    "test_open_ssl_over_tcp_stream_and_everything_else"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/python-trio/trio/issues/2000
    "trio/tests/test_ssl.py"
  ];

  # Tests are failing on Darwin
  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "trio"
  ];

  meta = with lib; {
    description = "An async/await-native I/O library";
    homepage = "https://github.com/python-trio/trio";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ catern ];
  };
}
