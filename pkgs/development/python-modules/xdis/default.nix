{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "6.0.5";
  format = "setuptools";

  # No support for Python 3.11, https://github.com/rocky/python-xdis/issues/98
  disabled = pythonOlder "3.6" || pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = "refs/tags/${version}";
    hash = "sha256-3mL0EuPHF/dithovrYvMjweYGwGhrN75N9MRfLjNC34=";
  };

  postPatch = ''
    # Our Python release is not in the test matrix
    substituteInPlace xdis/magics.py \
      --replace "3.10.4" "3.10.5 3.10.6 3.10.7 3.10.8 3.10.10 3.10.11 3.10.12 3.10.13 3.10.14"
  '';

  propagatedBuildInputs = [
    click
    six
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/rocky/python-xdis/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny ];
  };
}
