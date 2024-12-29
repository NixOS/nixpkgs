{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "6.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = "refs/tags/${version}";
    hash = "sha256-KgKTO99T2/be1sBs5rY3Oy7/Yl9WGgdG3hqqkZ7D7ZY=";
  };

  propagatedBuildInputs = [
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
  ];

  disabledTests = [
    # AssertionError: events did not match expectation
    "test_big_linenos"
    # AssertionError: False is not true : PYTHON VERSION 4.0 is not in magic.magics.keys
    "test_basic"
  ];

  meta = with lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = "https://github.com/rocky/python-xdis";
    changelog = "https://github.com/rocky/python-xdis/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny ];
  };
}
