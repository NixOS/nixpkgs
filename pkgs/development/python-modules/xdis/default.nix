{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "6.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = "refs/tags/${version}";
    hash = "sha256-Fn1cyUPMrn1SEXl4sdQwJiNHaY+BbxBDz3nKZY965/0=";
  };

  # Backport magics for newer newer python versions
  patches = [
    (fetchpatch {
      url = "https://github.com/rocky/python-xdis/commit/fcba74a7f64c5e2879ca0779ff10f38f9229e7da.patch";
      hash = "sha256-D7eJ97g4G6pmYL/guq0Ndf8yKTVBD2gAuUCAKwvlYbE=";
    })
    (fetchpatch {
      url = "https://github.com/rocky/python-xdis/commit/b66976ff53a2c6e17a73fb7652ddd6c8054df8db.patch";
      hash = "sha256-KO1y0nDTPmEZ+0/3Pjh+CvTdpr/p4AYZ8XdH5J+XzXo=";
    })
    (fetchpatch {
      url = "https://github.com/rocky/python-xdis/commit/a9f50c0ba77cdbf4693388404c13a02796a4221a.patch";
      hash = "sha256-gwMagKBY7d/+ohESTSl6M2IEjzABxfrddpdr58VJAk8=";
    })
    (fetchpatch {
      url = "https://github.com/rocky/python-xdis/commit/d9e15acae76a413667912a10fbf8259711ed9c65.patch";
      hash = "sha256-hpmKg+K1RiLSnmUIS8KtZRVBfvTO9bWbpsNhBFUM38o=";
    })
    (fetchpatch {
      url = "https://github.com/rocky/python-xdis/commit/b412c878d0bc1b516bd01612d46d8830c36a14ad.patch";
      hash = "sha256-W1JuIXYLO6iyjWiSnzCoXzFsedZjesq31gEPgrtjxas=";
    })
  ];

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
    changelog = "https://github.com/rocky/python-xdis/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      onny
      melvyn2
    ];
  };
}
