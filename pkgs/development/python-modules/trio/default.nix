{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, stdenv

# build-system
, setuptools

# dependencies
, attrs
, exceptiongroup
, idna
, outcome
, sniffio
, sortedcontainers

# tests
, astor
, coreutils
, jedi
, pyopenssl
, pytestCheckHook
, pytest-trio
, trustme
, yapf
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
  version = "0.24.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/6CadKa/gbhPhhOQn7C+ruhHV0UBg6ei4LR7RVwMrF0=";
  };

  postPatch = ''
    substituteInPlace src/trio/_tests/test_subprocess.py \
      --replace "/bin/sleep" "${coreutils}/bin/sleep"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
    idna
    outcome
    sniffio
    sortedcontainers
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
    export HOME=$TMPDIR
    # $out is first in path which causes "import file mismatch"
    PYTHONPATH=$PWD/src:$PYTHONPATH
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

  disabledTestPaths = [
    # linters
    "src/trio/_tests/tools/test_gen_exports.py"
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
