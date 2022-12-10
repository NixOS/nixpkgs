{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "6.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = version;
    hash = "sha256-CRZG898xCwukq+9YVkyXMP8HcuJ9GtvDhy96kxvRFks=";
  };

  postPatch = ''
    # Our Python release is not in the test matrix
    substituteInPlace xdis/magics.py \
      --replace "3.10.4" "3.10.5 3.10.6"
  '';

  propagatedBuildInputs = [
    click
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xdis"
  ];

  # import file mismatch:
  # imported module 'test_disasm' has this __file__ attribute:
  #   /build/source/pytest/test_disasm.py
  # which is not the same as the test file we want to collect:
  #   /build/source/test_unit/test_disasm.py
  disabledTestPaths = [
    "test_unit/test_disasm.py"
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny ];
  };
}
