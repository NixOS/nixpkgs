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
  version = "unstable-2022-04-13";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    # Support for later Python releases is missing in 6.0.3
    rev = "f888df7df5cb8839927e9187c258769cc77fb7a3";
    hash = "sha256-V1ws5GibRkutFRNcjlP7aW+AshSyWavXIxuwznVbRlU=";
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
    homepage = "https://github.com/rocky/python-xdis/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
