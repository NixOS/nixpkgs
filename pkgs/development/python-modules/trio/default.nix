{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  attrs,
  exceptiongroup,
  idna,
  outcome,
  sniffio,
  sortedcontainers,

  # tests
  astor,
  jedi,
  pyopenssl,
  pytestCheckHook,
  pytest-trio,
  trustme,
}:

let
  # escape infinite recursion with pytest-trio
  pytest-trio' = (pytest-trio.override { trio = null; }).overrideAttrs {
    # `pythonRemoveDeps` is not working properly
    dontCheckRuntimeDeps = true;
    doCheck = false;
    pythonImportsCheck = [ ];
  };
in
buildPythonPackage rec {
  pname = "trio";
  version = "0.30.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "trio";
    tag = "v${version}";
    hash = "sha256-spYHwVq3iNhnZQf2z7aTyDuSCiSl3X5PD6siXqLC4EA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    idna
    outcome
    sniffio
    sortedcontainers
  ]
  ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    astor
    jedi
    pyopenssl
    pytestCheckHook
    pytest-trio'
    trustme
  ];

  preCheck = ''
    export HOME=$TMPDIR
    # $out is first in path which causes "import file mismatch"
    PYTHONPATH=$PWD/src:$PYTHONPATH
  '';

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

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

  meta = {
    changelog = "https://github.com/python-trio/trio/blob/${src.tag}/docs/source/history.rst";
    description = "Async/await-native I/O library for humans and snake people";
    homepage = "https://github.com/python-trio/trio";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
