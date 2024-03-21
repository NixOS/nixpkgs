{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

, pythonOlder

, pytestCheckHook

, setuptools

  # for testing
, numpy
, importlib-resources

  # requirements
, editdistpy
}:

buildPythonPackage rec {
  pname = "symspellpy";
  version = "6.7.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  patches = [
    # patch for fix tests
    (fetchpatch {
      name = "fix-pkg-resources-deprecation-warning.patch";
      url = "https://patch-diff.githubusercontent.com/raw/mammothb/symspellpy/pull/150.patch";
      hash = "sha256-mdUJMrcPv5zczIRP+8u5vicz2IE1AUN3YP0+zg3jqZg=";
    })
  ];

  src = fetchFromGitHub {
    owner = "mammothb";
    repo = "symspellpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-mxBURUAT5Jf3+c3D0h3B7gvH1srrfjwGgKkPUBTRVOU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    editdistpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    importlib-resources
  ];

  pythonImportsCheck = [
    "symspellpy"
    "symspellpy.symspellpy"
  ];

  meta = with lib;
    {
      description = "Python port of SymSpell v6.7.1, which provides much higher speed and lower memory consumption";
      homepage = "https://github.com/mammothb/symspellpy";
      changelog = "https://github.com/mammothb/symspellpy/releases/tag/v${version}";
      license = licenses.mit;
      maintainers = with maintainers; [ vizid ];
    };
}
