{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "6.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    tag = version;
    hash = "sha256-k1SawlgbItbWe8J2pAxYOku/4CHyzWH3UR1j3kBZy1Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xdis" ];

  disabledTestPaths = [
    # import file mismatch:
    # imported module 'test_disasm' has this __file__ attribute:
    #   /build/source/pytest/test_disasm.py
    # which is not the same as the test file we want to collect:
    #   /build/source/test_unit/test_disasm.py
    "test_unit/test_disasm.py"

    # Doesn't run on non-2.7 but has global-level mis-import
    "test_unit/test_dis27.py"

    # Has Python 2 style prints
    "test/decompyle/test_nested_scopes.py"
  ];

  disabledTests = [
    # AssertionError: events did not match expectation
    "test_big_linenos"
    # AssertionError: False is not true : PYTHON VERSION 4.0 is not in magic.magics.keys
    "test_basic"
  ];

  meta = {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = "https://github.com/rocky/python-xdis";
    changelog = "https://github.com/rocky/python-xdis/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      onny
      melvyn2
    ];
  };
}
