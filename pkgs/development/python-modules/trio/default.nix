{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, sortedcontainers
, async-generator
, exceptiongroup
, idna
, outcome
, pytestCheckHook
, pytest-trio
, pyopenssl
, trustme
, sniffio
, stdenv
, jedi
, astor
, yapf
, coreutils
}:

let
  # escape infinite recursion with pytest-trio
  pytest-trio' = (pytest-trio.override {
    trio = null;
  }).overrideAttrs {
    doCheck = false;
    pythonImportsCheck = [];
  };
in
buildPythonPackage rec {
  pname = "trio";
  version = "0.22.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OIfPGMi8yJRDNCAwVGg4jax2ky6WaK+hxJqjgGtqzLM=";
  };

  propagatedBuildInputs = [
    attrs
    sortedcontainers
    async-generator
    idna
    outcome
    sniffio
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  # tests are failing on Darwin
  doCheck = !stdenv.isDarwin;

  nativeCheckInputs = [
    astor
    jedi
    pyopenssl
    pytestCheckHook
    pytest-trio'
    trustme
    yapf
  ];

  preCheck = ''
    substituteInPlace trio/_tests/test_subprocess.py \
      --replace "/bin/sleep" "${coreutils}/bin/sleep"

    export HOME=$TMPDIR
  '';

  # It appears that the build sandbox doesn't include /etc/services, and these tests try to use it.
  disabledTests = [
    "getnameinfo"
    "SocketType_resolve"
    "getprotobyname"
    "waitpid"
    "static_tool_sees_all_symbols"
    # tests pytest more than python
    "fallback_when_no_hook_claims_it"
    # requires mypy
    "test_static_tool_sees_class_members"
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  meta = {
    description = "An async/await-native I/O library for humans and snake people";
    homepage = "https://github.com/python-trio/trio";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
