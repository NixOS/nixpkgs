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

  disabledTestPaths = [
    # Our Python release is not in the test matrix
    "test_unit/test_disasm.py"
  ];

  disabledTests = [
    "test_big_linenos"
    "test_basic"
  ];

  meta = with lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = "https://github.com/rocky/python-xdis";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
