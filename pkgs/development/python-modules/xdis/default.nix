{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "6.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = "refs/tags/${version}";
    hash = "sha256-Fn1cyUPMrn1SEXl4sdQwJiNHaY+BbxBDz3nKZY965/0=";
  };

  # Backport magics for newer newer python versions
  # 6.1.1 only supports up to 3.12.4 while nixpkgs is already on 3.12.5+
  patches = [
    (fetchpatch {
      url = "https://github.com/rocky/python-xdis/commit/fcba74a7f64c5e2879ca0779ff10f38f9229e7da.patch";
      hash = "sha256-D7eJ97g4G6pmYL/guq0Ndf8yKTVBD2gAuUCAKwvlYbE=";
    })
    (fetchpatch {
      url = "https://github.com/rocky/python-xdis/commit/b66976ff53a2c6e17a73fb7652ddd6c8054df8db.patch";
      hash = "sha256-KO1y0nDTPmEZ+0/3Pjh+CvTdpr/p4AYZ8XdH5J+XzXo=";
    })
  ];

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
    changelog = "https://github.com/rocky/python-xdis/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      onny
      melvyn2
    ];
  };
}
